class GiftCard < ActiveRecord::Base
  belongs_to :gift

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_confirmation_of :email
  validates_presence_of :email_confirmation
  validates_length_of :email, :within => 3..100
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/
end
