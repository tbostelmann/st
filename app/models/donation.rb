# == Schema Information
# Schema version: 20090422073021
#
# Table name: donations
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  donation_status :string(255)     default("pending")
#  created_at      :datetime
#  updated_at      :datetime
#

require 'money'

class Donation < ActiveRecord::Base
  STATUS_PENDING = 'pending'
  STATUS_COMPLETE = 'complete'
  STATUS_CANCELED = 'canceled'

  has_many :donation_line_items
  has_many :payments
  has_many :financial_transactions
  belongs_to :user

  validates_presence_of :donation_line_items
  validates_presence_of :donation_status

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
