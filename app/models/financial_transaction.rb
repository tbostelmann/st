# == Schema Information
# Schema version: 20090422073021
#
# Table name: financial_transactions
#
#  id          :integer(4)      not null, primary key
#  donation_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#
require 'money'

class FinancialTransaction < ActiveRecord::Base
  CANCELED_REVERSAL = 'Canceled_Reversal'
  DENIED = 'Denied'
  EXPIRED = 'Expired'
  FAILED = 'Failed'
  PENDING = 'Pending'
  REFUNDED = 'Refunded'
  REVERSED = 'Reversed'
  PROCESSED = 'Processed'
  VOIDED = 'Voided'

  belongs_to :donation
  has_many :line_items

  def self.create_pay_pal_transaction(raw_post)
    notification = Paypal::Notification.new(request.raw_post)
    donation = Donation.find(notification.invoice())

    ft = create(:donation => donation, :raw => raw_post)

    donation.donation_line_items.each do |dli|
      ftli = LineItem.create_complete_transaction(ft, dli)
      ft.line_items << ftli
    end
    donation.donation_status = Donation::STATUS_COMPLETE


    if notification.acknowledge
      ft = create(:donation => donation, :status => notification.status, :raw => raw_post)

      @payment = Payment.find_by_transaction_id(notification.transaction_id) ||
        @donation.payments.create(:account => notify.account,
          :currency => notify.currency, :gross => notify.gross,
          :fee => notify.fee, :received_at => notify.received_at,
          :status => notify.status, :test => notify.test?,
          :transaction_id => notify.transaction_id,
          :type => notify.type, :raw => raw_post)
      begin
        if notify.complete?
          @payment.status = notify.status
        else
          case notify.status
          when 'Canceled_Reversal'
            # payment_status A reversal has been canceled. For example,
            # you won a dispute with the customer, and the funds for the
            # transaction that was reversed have been returned to you.
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

    return ft
  end

  def post_to_accounts
    line_items.each do |li|
      li.account.post_line_item(li)
    end  
  end
end
