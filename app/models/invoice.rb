# == Schema Information
# Schema version: 20090422073021
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
end
