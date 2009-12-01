# == Schema Information
# Schema version: 20091117074908
#
# Table name: gift_cards
#
#  id           :integer(4)      not null, primary key
#  first_name   :string(255)
#  last_name    :string(255)
#  email        :string(255)
#  message      :string(255)
#  line_item_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class GiftCard < ActiveRecord::Base
  # A payment has been completed
  STATUS_COMPLETED = 'Completed'

  belongs_to :gift_from, :class_name => 'Gift', :foreign_key => :line_item_from_id
  belongs_to :gift_to, :class_name => 'Gift', :foreign_key => :line_item_to_id

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_confirmation_of :email
  validates_presence_of :email_confirmation
  validates_length_of :email, :within => 3..100
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/
end
