require 'money'

class PledgesController < BaseController
  
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
    @user = current_user
    @storg = Organization.find_savetogether_org

    @pledge = Pledge.new(params[:pledge])

    respond_to do |format|
      if @pledge.save
        format.html # create.html.erb
      else
        format.html { render :action => "new", :saver_id => params[:saver_id] }
      end
    end
  end

  def done
    notify = Paypal::Notification.new(request.raw_post)
    
    handle_pay_pal_notification(notification)

    @donation = Pledge.find(notification.invoice())

    if current_user
      redirect_to :controller => 'users', :action => 'show', :id => current_user
    else
      redirect_to :controller => 'users', :action => 'new', :donation_id => notification.invoice()
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


  def cancel
    handle_pay_pal_notification(notification)
  end

  private

  def handle_pay_pal_notification(notify)
    notify = Paypal::Notification.new(request.raw_post)
    @donation = Pledge.find(notify.invoice())

    # TODO: need to put this in a transaction
    ft = FinancialTransaction.create_complete_transaction(notify)
    ft.post_to_accounts


  end
          
  def new_default_donation(user, asset_development_case)
    stOrg = Organization.find_savetogether_org
    # TODO: need to addn donation_status default setting to initializer
    donation = Pledge.new(:user => user, :saver => asset_development_case.user)
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
