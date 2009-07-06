# == Schema Information
# Schema version: 20090422073021
#
# Table name: line_items
#
#  id           :integer(4)      not null, primary key
#  cents        :integer(4)
#  invoice_id   :integer(4)
#  from_user_id :integer(4)
#  to_user_id   :integer(4)
#  status       :string(255)     default("Pending")
#  type         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Donation < LineItem
  
  def self.suggest_percentage_of(to, from, percentage, amount)
    suggested_amount = (amount.cents.to_f * percentage).to_i
    Donation.new(:from_user_id => to, :to_user_id => from, :cents => "#{suggested_amount}")
  end
  
end
