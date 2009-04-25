# == Schema Information
# Schema version: 20090422073021
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
  has_many :line_items
  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :account
  validates_presence_of :cents

  def account_id=(account_id)
    self.account = Account.find(account_id)
  end

  def account_id
    self.account.id
  end
end
