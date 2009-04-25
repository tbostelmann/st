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
        format.html { render :action => "new", :user_id => @user_id }
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
    notify = Paypal::Notification.new(request.raw_post)
    donation = Donation.find(notify.invoice())

    if notify.acknowledge
      @payment = Payment.find_by_confirmation(notify.transaction_id) ||
        donation.payments.create(:account => notify.account,
          :currency => notify.currency, :gross => notify.gross,
          :fee => notify.fee, :received_at => notify.received_at,
          :status => notify.status, :test => notify.test?,
          :transaction_id => notify.transaction_id, :type => notify.type)
      begin
        if notify.complete?
          @payment.status = notify.status
        else
          case notify.status
          when 'Canceled_Reversal'
            # payment_status A reversal has been canceled. For example,
            # you won a dispute with the customer, and the funds for the
            # transaction that was reversed have been returned to you.
          when 'Created'
            # A German ELV payment is made using Express Checkout.
          when 'Denied'
            # Denied: You denied the payment. This happens only if the
            # payment was previously pending because of possible
            # reasons described for the payment_status pending_reason
            # variable or the Fraud_Management_Filters_x variable.
          when 'Expired'
            # This authorization has expired and cannot be captured.
          when 'Failed'
            # The payment has failed. This happens only if the payment
            # was made from your customer’s bank account.
          when 'Pending'
            # The payment is pending. See pending_reason for more
            # information.
          when 'Refunded'
            # You refunded the payment.
          when 'Reversed'
            # A payment was reversed due to a chargeback or other type
            # of reversal. The funds have been removed from your account
            # balance and returned to the buyer. The reason for the
            # reversal is specified in the ReasonCode element.
          when 'Processed'
            # A payment has been accepted.
          when 'Voided'
            # This authorization has been voided.
          else
            # Uh...don't recognize the status that was sent
          end
        end
      rescue => e
        @payment.status = 'Error'
        raise
      ensure
        @payment.save
      end
    end
    render :nothing => true
  end

  def done
    # TODO: need to figure out how to handle anonymous donations - for now just complete the donation
    donation_id = params[:donation_id]
    @donation = Donation.find(donation_id)

    if @donation.nil?
      # TODO: need to handle this gracefully
      raise "no such donation"
    else
      # TODO: need to put this in a transaction
      ft = FinancialTransaction.create_complete_transaction(@donation)
      ft.post_to_accounts

      if current_user
        redirect_to :controller => 'users', :action => 'show', :id => current_user
      else
        redirect_to :controller => 'users', :action => 'new', :donation_id => @donation.id
      end
    end
  end

  def cancel
    
  end

  private
          
  def new_default_donation(user, asset_development_case)
    stOrg = Organization.find_savetogether_org
    # TODO: need to addn donation_status default setting to initializer
    donation = Donation.new(:user => user)
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
