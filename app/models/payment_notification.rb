class PaymentNotification < ActiveRecord::Base
  include ActiveMerchant::Billing::Integrations

  has_many :financial_transactions

  composed_of :notification,
          :class_name => 'Paypal::Notification',
          :converter => Proc.new {|data| Paypal::Notification.new(data)},
          :constructor => Proc.new { Paypal::Notification.new(raw_data) }  
end