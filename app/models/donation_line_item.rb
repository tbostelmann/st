require 'money'

class DonationLineItem < ActiveRecord::Base
  belongs_to :donation
  has_one :account
  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :account
  validates_presence_of :donation
  validates_presence_of :cents
end
