# == Schema Information
# Schema version: 20090422073021
#
# Table name: payment_notifications
#
#  id         :integer(4)      not null, primary key
#  raw_data   :text
#  created_at :datetime
#  updated_at :datetime
#

class PaymentNotification < ActiveRecord::Base
  include ActiveMerchant::Billing::Integrations

  composed_of :notification,
          :class_name => 'Paypal::Notification',
          :mapping => %w(raw_data raw_data),
          :converter => Proc.new {|data| Paypal::Notification.new(data)},
          :constructor => Proc.new { |data| Paypal::Notification.new(data) }  
end
