# == Schema Information
# Schema version: 20090701201617
#
# Table name: invoices
#
#  id                 :integer(4)      not null, primary key
#  donor_id           :integer(4)
#  type               :string(255)
#  notification_email :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Invoice < ActiveRecord::Base
  has_many :line_items, :foreign_key => :invoice_id
  has_many :donations, :foreign_key => :invoice_id
  has_many :fees, :foreign_key => :invoice_id
  has_many :gifts, :foreign_key => :invoice_id

  def find_line_item_with_id (id)
    line_items.each do |d|
      if d.id == id.to_i
        return d
      end
    end
    return
  end

  def add_line_item(li)
    if !li.nil?
      li.invoice = self
      line_items << li
    end
  end
end
