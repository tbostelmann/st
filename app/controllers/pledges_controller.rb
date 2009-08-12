require 'money'

class PledgesController < BaseController
  include ApplicationHelper
  include ActiveMerchant::Billing::Integrations

  protect_from_forgery :except => [:notify]

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
    @pledge = find_pledge
    if @pledge.find_donation_with_to_user_id(Organization.find_savetogether_org.id)
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
    @pledge = find_pledge
    donation = @pledge.find_donation_with_to_user_id(params[:donation][:to_user_id])
    donation.cents = params[:donation][:cents]
    donation.save!

    render_show_or_edit
  end

  def remove_from_pledge
    @pledge = find_pledge
    @pledge.remove_donation_with_to_user_id(params[:to_user_id])
    @pledge.save!

    render_show_or_edit
  end
  
  def edit
    @pledge = find_pledge

    render 'edit'
  end

  def show
    @pledge = find_pledge
    if current_user
      @user = current_user
      @pledge.set_donor_id(@user.id)
      @pledge.save
      @pledge = find_pledge
    end 

    render 'show'
  end

  def savetogether_ask
    if current_user.nil?
      redirect_to signup_or_login_path
    elsif find_pledge.find_donation_with_to_user_id(Organization.find_savetogether_org.id)
      show
    else
      @pledge = find_pledge
      @storg = Organization.find_savetogether_org
      @donation = Donation.suggest_percentage_of(current_user.id, @storg.id, 0.15, @pledge.total_amount_for_donations)
    end
  end

  def done
    session[:pledge_id] = nil
    pn = PaymentNotification.create(:raw_data => request.query_string)
    notification = pn.notification

    @pledge = Pledge.find(notification.invoice)
    if @pledge.nil?
      raise "Invoice not found"
    elsif @pledge.donor.id != current_user.id
      raise "Invoice is not owned by this user"
    end

    if ENV['RAILS_ENV'] == 'test' || notification.acknowledge
      @pledge.process_paypal_notification(notification)
      @pledge.save!
    else
      # We're assuming that a notification that is not acknowledged will be sent again.
    end

    UserNotifier.deliver_donation_thanks_notification(current_user)
    flash[:thank_you_for_pledge] = true
    redirect_to :controller => :donor_surveys, :action => :show, :thank_you_for_pledge => true
  end

  def notify
    pn = PaymentNotification.create(:raw_data => request.raw_post)
    notification = pn.notification

    pledge = Pledge.find(notification.invoice)
    if pledge.nil?
      raise "Invoice not found"
    end

    if ENV['RAILS_ENV'] == 'test' || notification.acknowledge
      pledge.process_paypal_notification(notification)
      pledge.save!
    else
      # We're assuming that a notification that is not acknowledged will be sent again.
    end

    render :nothing => true
  end


  def cancel
    
  end

  private

  def add_donation_to_pledge
    @pledge = find_pledge
    if params[:donation]
      donation = Donation.new(params[:donation])
      @pledge.add_donation(donation)
      @pledge.save!
      @pledge = find_pledge
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
