require 'money'

class PledgesController < BaseController
  include ActiveMerchant::Billing::Integrations

  protect_from_forgery :except => [:ipn]

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

  # POST /pledges/review
  def create
    @saver = Saver.find(params[:saver_id])
    @storg = Organization.find_savetogether_org
    @pledge = Pledge.new(params[:pledge])

    if current_user
      update_pledge(current_user)
      respond_to do |format|
        if @pledge.save
          format.html # create.html.erb
        else
          format.html { render :action => "new", :saver_id => params[:saver_id] }
        end
      end
    elsif params[:commit] == :log_in.l
      self.current_user = Donor.authenticate(params[:login], params[:password])

      respond_to do |format|
        if logged_in?
          if params[:remember_me] == "1"
            self.current_user.remember_me
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
          end

          flash[:notice] = :thanks_youre_now_logged_in.l
          current_user.track_activity(:logged_in)

          update_pledge(current_user)
        else
          flash[:notice] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
          format.html { render :action => "new", :saver_id => params[:saver_id] }
        end

        if  @pledge.save
          format.html # create.html.erb
        else
          format.html { render :action => "new", :saver_id => params[:saver_id] }
        end 
      end
    else
      @user       = Donor.new(params[:donor])
      @user.role  = Role[:member]
      @user.birthday = 21.years.ago.to_s :db
      update_pledge(@user)

      respond_to do |format|
        if @user.save! && @pledge.save && (!AppConfig.require_captcha_on_signup || verify_recaptcha(@user))
          format.html # create.html.erb
        else
          format.html { render :action => "new", :saver_id => params[:saver_id] }
        end
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

    if notification.acknowledge || ENV['RAILS_ENV'] == 'test'
      pledge.process_paypal_notification(notification)
      pledge.save!
    else
      # We're assuming that a notification that is not acknowledged will be sent again.
    end

    redirect_to :controller => 'donors', :action => 'show'
  end

  def notify
    pn = PaymentNotification.create(:raw_data => request.query_string)
    notification = pn.notification

    pledge = Pledge.find(notification.invoice)
    if pledge.nil?
      raise "Invoice not found"
    end

    if notification.acknowledge || ENV['RAILS_ENV'] == 'test'
      pledge.process_paypal_notification(notification)
      pledge.save!
    else
      # We're assuming that a notification that is not acknowledged will be sent again.
    end

    render :nothing => true
  end


  def cancel
    handle_pay_pal_notification(notification)
  end

  private
  def update_pledge(user)
    @pledge.donor = user
    @pledge.donations.each do |donation|
      donation.from_user = user
    end
  end  
end
