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

class LineItem < ActiveRecord::Base
  belongs_to :financial_transaction
  belongs_to :donation_line_item
  belongs_to :account

  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :account
  validates_presence_of :donation_line_item
  validates_presence_of :financial_transaction

  def self.create_complete_transaction(ft, dli)
    li = create(
        :account => dli.account,
        :financial_transaction => ft,
        :donation_line_item => dli,
        :amount => dli.amount,
        :debit => false)
    ft.line_items << li
    return li
  end
end
