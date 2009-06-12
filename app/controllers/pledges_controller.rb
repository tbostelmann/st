require 'money'

class PledgesController < BaseController
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

  def continue
    @pledge = session[:pledge]
    @saver = Saver.find(session[:saver_id])
    @storg = Organization.find_savetogether_org
    
    update_pledge_with_donor
    @pledge.save!
    session[:pledge] = nil
    session[:saver_id] = nil
    render 'create' #post AppConfig.paypal_url, paypal_redirect_params(@pledge)
  end

  # POST /pledges/create
  def create  
    @saver = Saver.find(params[:saver_id])
    @storg = Organization.find_savetogether_org
    @pledge = Pledge.new(params[:pledge])

    respond_to do |format|
      if @pledge.valid? && @pledge.donations.size > 0
        if current_user
          update_pledge_with_donor
          @pledge.save!
          format.html #{ redirect_to post AppConfig.paypal_url, paypal_redirect_params(@pledge)}
        else
          session[:pledge] = @pledge
          session[:saver_id] = params[:saver_id]
          format.html { redirect_to signup_or_login_path }
        end
      else
        format.html { render :action => "new", :saver_id => params[:saver_id] }
      end
    end
  end

  def done
    pn = PaymentNotification.create(:raw_data => request.query_string)
    notification = pn.notification

    pledge = Pledge.find(notification.invoice)
    if pledge.nil?
      raise "Invoice not found"
    elsif pledge.donor.id != current_user.id
      raise "Invoice is not owned by this user"
    end

    if ENV['RAILS_ENV'] == 'test' || notification.acknowledge
      pledge.process_paypal_notification(notification)
      pledge.save!
    else
      # We're assuming that a notification that is not acknowledged will be sent again.
    end
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
