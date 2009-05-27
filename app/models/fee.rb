# == Schema Information
# Schema version: 20090422073021
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  cents      :integer(4)
#  invoice_id :integer(4)
#  user_id    :integer(4)
#  donor_id   :integer(4)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Fee < LineItem
end
