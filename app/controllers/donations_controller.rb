class DonationsController < BaseController
  
  # GET /donations/new/{:asset_development_case_id}
  # GET /donations/new/{:asset_development_case_id}.xml
  def new
    stOrg = Organization.find_savetogether_org
    @adc = AssetDevelopmentCase.find(params[:asset_development_case_id])
    user = current_user
    @donation = Donation.new(:user => user)
    @donation.donation_line_items << DonationLineItem.new(
            :description => "Donation to #{@adc.user.display_name}",
            :amount => Money.new(5000), # TODO: this should be a configurable value
            :account => @adc.account,
            :donation => @donation)
    @donation.donation_line_items << DonationLineItem.new(
            :description => "Donation to #{stOrg.name}",
            :amount => Money.new(500), # TODO: this value should be a configuration value
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
    @beneficiary = Beneficiary.find(params[:beneficiary_id])

    # TODO: This probably needs to be combined into a model method - not sure what the method signature would look like, though (best practice here?)
    @donation = Donation.new(params[:donation])
    bpli = DonationLineItem.new(params[:bpli])
    bpli.donation = @donation
    @donation.donation_line_items << bpli
    stpli = DonationLineItem.new(params[:stpli])
    stpli.donation = @donation
    @donation.donation_line_items << stpli

    @total = 0
    @donation.donation_line_items.each do |pli|
      @total = @total.to_f + pli.amount.to_f
    end

    respond_to do |format|
      if @donation.save
        format.html # new.html.erb
        format.xml  { render :xml => @donation }
      else
        format.html { render :action => "new" }
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
