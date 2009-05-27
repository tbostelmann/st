# == Schema Information
# Schema version: 20090422073021
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  cents      :integer(4)
#  invoice_id :integer(4)
#  user_id    :integer(4)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'money'

class LineItem < ActiveRecord::Base
  has_many :financial_transactions
  belongs_to :invoice
  belongs_to :user
  belongs_to :donor

  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }
end
