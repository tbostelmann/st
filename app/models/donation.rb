# == Schema Information
# Schema version: 20090513215116
#
# Table name: donations
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  saver_id            :integer(4)
#  donation_status     :string(255)     default("pending")
#  created_at          :datetime
#  updated_at          :datetime
#  notification_email  :string(255)
#

require 'money'

class Donation < ActiveRecord::Base
  STATUS_PENDING = 'pending'
  STATUS_COMPLETE = 'complete'
  STATUS_CANCELED = 'canceled'

  has_many :donation_line_items
  has_many :payments
  has_many :financial_transactions
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :saver, :class_name => "User", :foreign_key => "saver_id" 

  validates_presence_of :donation_line_items
  validates_presence_of :donation_status
  validates_presence_of :saver
  validates_presence_of :notification_email
  validates_length_of   :notification_email, :within => 3..100
  validates_format_of   :notification_email, :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/

  def donation_line_item_attributes=(dli_attributes)
    dli_attributes.each do |index, attributes|
      donation_line_items.build(attributes)
    end
  end

  def user_id=(user_id)
    self.user = User.find(user_id)
  end

  def user_id
    self.user.id
  end

  def amount
    amount = Money.new(0)
    self.donation_line_items.each do |dli|   
      amount += dli.amount
    end
    
    return amount
  end
end
