# == Schema Information
# Schema version: 20090422073021
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  owner_type :string(255)
#  cents      :integer(4)      default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  has_many :line_items
  composed_of :balance, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }

  def post_line_item(li)
    # TODO: needs to handle debit/credit correctly depending on account type (asset/liability)
    # TODO: for now we're assuming it's always a credit
    self.balance = self.balance + li.amount
    self.save
  end
end
