# == Schema Information
# Schema version: 20090422073021
#
# Table name: line_items
#
#  id                       :integer(4)      not null, primary key
#  cents                    :integer(4)
#  debit                    :boolean(1)
#  financial_transaction_id :integer(4)
#  account_id               :integer(4)
#  donation_line_item_id    :integer(4)
#  created_at               :datetime
#  updated_at               :datetime
#

require 'money'

class LineItem < ActiveRecord::Base
  has_many :financial_transactions, :order => :position
  belongs_to :invoice 

  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :invoice
end
