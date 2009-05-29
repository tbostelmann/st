# == Schema Information
# Schema version: 20090422073021
#
# Table name: financial_transactions
#
#  id                      :integer(4)      not null, primary key
#  line_item_id            :integer(4)
#  payment_notification_id :integer(4)
#  status                  :string(255)
#  position                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#

require 'money'

class FinancialTransaction < ActiveRecord::Base
  # payment_status A reversal has been canceled. For example,
  # you won a dispute with the customer, and the funds for the
  # transaction that was reversed have been returned to you.
  STATUS_CANCELED_REVERSAL = 'Canceled_Reversal'

  # Denied: You denied the payment. This happens only if the
  # payment was previously pending because of possible
  # reasons described for the payment_status pending_reason
  # variable or the Fraud_Management_Filters_x variable.
  STATUS_DENIED = 'Denied'

  # This authorization has expired and cannot be captured.
  STATUS_EXPIRED = 'Expired'

  # The payment has failed. This happens only if the payment
  # was made from your customer’s bank account.
  STATUS_FAILED = 'Failed'

  # The payment is pending. See pending_reason for more
  # information.
  STATUS_PENDING = 'Pending'

  # You refunded the payment.
  STATUS_REFUNDED = 'Refunded'

  # A payment was reversed due to a chargeback or other type
  # of reversal. The funds have been removed from your account
  # balance and returned to the buyer. The reason for the
  # reversal is specified in the ReasonCode element.
  STATUS_REVERSED = 'Reversed'

  # A payment has been accepted.
  STATUS_PROCESSED = 'Processed'

  # This authorization has been voided.
  STATUS_VOIDED = 'Voided'

  belongs_to :line_item
  belongs_to :payment_notification

  validates_presence_of :status
  validates_presence_of :line_item
  validates_presence_of :payment_notification 
end
