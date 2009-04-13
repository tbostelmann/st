# == Schema Information
# Schema version: 20090408231608
#
# Table name: donation_line_items
#
#  id          :integer(4)      not null, primary key
#  cents       :integer(4)
#  donation_id :integer(4)
#  description :string(255)
#  account_id  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'money'

class DonationLineItem < ActiveRecord::Base
  belongs_to :donation
  belongs_to :account
  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :account
  validates_presence_of :cents
  validates_presence_of :donation

  def account_id=(account_id)
    self.account = Account.find(account_id)
  end

  def account_id
    self.account.id
  end
end
