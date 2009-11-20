require 'money'

class PledgesController < BaseController
  include ApplicationHelper
  include ActiveMerchant::Billing::Integrations

  protect_from_forgery :except => [:notify, :done]

  # GET /pledges/new/{:saver_id}
  def new
    @saver = Saver.find(params[:saver_id])
    @user = current_user
    @storg = Organization.find_savetogether_org

    @pledge = Pledge.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def render_show_or_edit
    @pledge = get_or_init_pledge
    if @pledge.find_line_item_with_to_user_id(Organization.find_savetogether_org.id)
      show
    else
      edit
    end
  end

  def add_to_pledge
    add_donation_to_pledge

    render_show_or_edit
  end

  def add_savetogether_to_pledge
    add_donation_to_pledge

    show
  end

  def update_donation_amount
    @pledge = get_pledge
    donation = @pledge.find_line_item_with_to_user_id(params[:donation][:to_user_id])
    donation.cents = params[:donation][:cents]
    donation.save!

    render_show_or_edit
  end

  def remove_from_pledge
    @pledge = get_pledge
    @pledge.remove_donation_with_to_user_id(params[:to_user_id])
    @pledge.save!

    render_show_or_edit
  end
  
  def edit
    @pledge = get_or_init_pledge

    render 'edit'
  end

  def show
    @pledge = get_or_init_pledge
    if current_user
      @user = current_user
      @pledge.set_donor_id(@user.id)
      @pledge.save
      @pledge = get_or_init_pledge
    end 

    render 'show'
  end

  def savetogether_ask
    if current_user.nil?
      redirect_to signup_or_login_path
    elsif get_or_init_pledge.find_line_item_with_to_user_id(Organization.find_savetogether_org.id)
      show
    else
      @pledge = get_or_init_pledge
      @storg = Organization.find_savetogether_org
      @donation = Donation.suggest_percentage_of(current_user.id, @storg.id, 0.15, @pledge.total_amount_for_donations)
    end
  end

  def done
    if get_pledge.nil?
      logger.warn "Expecting pledge to be present in session but was not"
    end

    if current_user.nil?
      logger.warn "Expecting a user session to be present but was not"
    end

    pn = PaymentNotification.create(:raw_data => request.query_string)
    notification = pn.notification

    @pledge = Pledge.find(notification.invoice)
    session[:pledge_id] = nil
    if @pledge.nil?
      raise ArgumentError, :argument_error_invoice_with_id_not_found.l(:id => notification.invoice)
    end

    if !current_user.nil? && @pledge.donor.id != current_user.id
      logger.warn "User with id #{current_user.id} trying to update a pledge with donor #{@pledge.donor.id}"
    end

    handle_notification(@pledge, notification)

    flash[:thank_you_for_pledge] = true
    redirect_to :protocol => 'http', :controller => :donor_surveys, :action => :show, :thank_you_for_pledge => true
  end

  def notify
    pn = PaymentNotification.create(:raw_data => request.raw_post)
    notification = pn.notification

    @pledge = Pledge.find(notification.invoice)
    if @pledge.nil?
      raise ArgumentError, :argument_error_invoice_with_id_not_found.l(:id => notification.invoice)
    end

    handle_notification(@pledge, notification)

    render :nothing => true
  end


  def cancel
  end

  private

  def handle_notification(pledge, notification)
    Pledge.transaction do
      pledge.process_paypal_notification(notification)
      pledge.save!
      unless ENV['RAILS_ENV'] == 'test' || notification.acknowledge
        raise RuntimeError, :runtime_error_notification_acknowledge_failed.l
      end
    end
  end

  def add_donation_to_pledge
    @pledge = get_or_init_pledge
    if params[:donation]
      donation = Donation.new(params[:donation])
      @pledge.add_donation(donation)
      @pledge.save!
      @pledge = get_pledge
    end
  end

  def update_pledge_with_donor
    @pledge.donor = current_user
    @pledge.donations.each do |donation|
      donation.from_user = current_user
    end
  end

  def paypal_redirect_params(pledge)
    redirect_params = {
      :cancel_return => url_for(:only_path => false, :action => 'cancel'),
      :bn => "ActiveMerchant",
      :redirect_cmd => "_cart",
      :cmd => "_cart",
      :upload => "1",
      :notify_url => url_for(:only_path => false, :action => 'notify'),
      :charset => "utf-8",
      :return => url_for(:only_path => false, :action => 'done'),
      :invoice => @pledge.id,
      :tax => "0.00",
      :business => AppConfig.paypal_account,
      :address_override => "0",
      :shipping => "0.00",
      :no_note => "1",
      :no_shipping => "1",
      :currency_code => "USD"
    }
    pledge.line_items.each_with_index do |li, index|
      redirect_params["item_number_#{index + 1}"] = li.to_user.id
      redirect_params["item_name_#{index + 1}"] = li.to_user.first_name
      redirect_params["amount_#{index + 1}"] = li.amount
    end

    return redirect_params
  end
end
