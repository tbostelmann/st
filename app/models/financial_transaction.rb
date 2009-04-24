# == Schema Information
# Schema version: 20090422073021
#
# Table name: financial_transactions
#
#  id          :integer(4)      not null, primary key
#  donation_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class FinancialTransaction < ActiveRecord::Base
  belongs_to :donation
  has_many :line_items

  def self.create_complete_transaction(donation)
    ft = create(:donation => donation)
    donation.donation_line_items.each do |dli|
      ftli = LineItem.create_complete_transaction(ft, dli)
      ft.line_items << ftli
    end
    donation.donation_status = Donation::STATUS_COMPLETE
    return ft
  end

  def post_to_accounts
    line_items.each do |li|
      li.account.post_line_item(li)
    end  
  end
end
