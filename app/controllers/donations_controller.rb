require 'money'

class DonationsController < BaseController
  
  # GET /donations/new/{:saver_id}
  # GET /donations/new/{:saver_id}.xml
  def new
    @saver_id = params[:saver_id]
    @adc = AssetDevelopmentCase.find_by_user_id(@saver_id)
    user = current_user
    @donation = new_default_donation(user, @adc)

    respond_to do |format|
      if @donation.valid?
        format.html # new.html.erb
        format.xml  { render :xml => @donation }
      else
        format.html { render :action => "new", :saver_id => @saver_id }
        format.xml  { render :xml => @donation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /donations
  # POST /donations.xml
  def create
    # TODO: need to addn donation_status default setting to initializer
    @donation = Donation.new(params[:donation])

    respond_to do |format|
      if @donation.save
        format.html # new.html.erb
        format.xml  { render :xml => @donation }
      else
        format.html { render :action => "new", :user_id => @user_id }
        format.xml  { render :xml => @donation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def notify
    handle_pay_pal

    render :nothing => true
  end

  def done


    handle_pay_pal_notification(notification)

    @donation = Donation.find(notification.invoice())

    if current_user
      redirect_to :controller => 'users', :action => 'show', :id => current_user
    else
      redirect_to :controller => 'users', :action => 'new', :donation_id => notification.invoice()
    end
  end

  def cancel
    
  end

  private

  def handle_pay_pal_notification(notify)
    notify = Paypal::Notification.new(request.raw_post)
    @donation = Donation.find(notify.invoice())

    # TODO: need to put this in a transaction
    ft = FinancialTransaction.create_complete_transaction(notify)
    ft.post_to_accounts


  end
          
  def new_default_donation(user, asset_development_case)
    stOrg = Organization.find_savetogether_org
    # TODO: need to addn donation_status default setting to initializer
    donation = Donation.new(:user => user, :saver => asset_development_case.user)
    donation.donation_line_items << DonationLineItem.new(
            :description => "Donation to #{asset_development_case.user.display_name}",
            :amount => '50', # TODO: this should be a configurable value
            :account => asset_development_case.account,
            :donation => donation)
    donation.donation_line_items << DonationLineItem.new(
            :description => "Donation to #{stOrg.name}",
            :amount => '5', # TODO: this value should be a configuration value
            :account => stOrg.account,
            :donation => donation)

    return donation
  end
end
