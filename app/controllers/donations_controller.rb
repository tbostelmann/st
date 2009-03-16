require 'money'

class DonationsController < BaseController
  
  # GET /donations/new/{:saver_id}
  # GET /donations/new/{:saver_id}.xml
  def new
    stOrg = Organization.find_savetogether_org
    @saver_id = params[:saver_id]
    @adc = AssetDevelopmentCase.find_by_user_id(@saver_id)
    user = current_user
    @donation = Donation.new(:user => user)
    @donation.donation_line_items << DonationLineItem.new(
            :description => "Donation to #{@adc.user.display_name}",
            :amount => '50', # TODO: this should be a configurable value
            :account => @adc.account,
            :donation => @donation)
    @donation.donation_line_items << DonationLineItem.new(
            :description => "Donation to #{stOrg.name}",
            :amount => '5', # TODO: this value should be a configuration value
            :account => stOrg.account,
            :donation => @donation)    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @donation }
    end
  end

  # POST /donations
  # POST /donations.xml
  def create
    @saver_id = params[:saver_id]
    @adc = AssetDevelopmentCase.find_by_user_id(@saver_id)
    @donation = Donation.new(:user => current_user)
    sdli = DonationLineItem.new(
            :amount => params[:sdli][:amount].to_money,
            :account => Account.find(params[:sdli][:account_id]),
            :description => params[:sdli][:description])
    sdli.donation = @donation
    @donation.donation_line_items << sdli
    stdli = DonationLineItem.new(
            :amount => params[:stdli][:amount].to_money,
            :account => Account.find(params[:stdli][:account_id]),
            :description => params[:stdli][:description])
    stdli.donation = @donation
    @donation.donation_line_items << stdli

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
    
  end

  def done

  end

  def cancel
    
  end
end
