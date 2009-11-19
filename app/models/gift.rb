# == Schema Information
# Schema version: 20091117074908
#
# Table name: line_items
#
#  id           :integer(4)      not null, primary key
#  cents        :integer(4)
#  invoice_id   :integer(4)
#  from_user_id :integer(4)
#  to_user_id   :integer(4)
#  status       :string(255)
#  type         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Gift < LineItem
  has_one :gift_card, :class_name => 'GiftCard', :foreign_key => :line_item_id, :autosave => true
  
  validates_presence_of :gift_card
end
