class Pledge < ActiveRecord::Base
  belongs_to :invoice
  
  validates_length_of   :notification_email, :within => 0..100
  validates_format_of   :notification_email,
                        :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/,
                        :message => "must be in form of \"yourname@host.com\" (or .org, .net, etc.)"
  validates_confirmation_of :notification_email, :message => "should match confirmation"
end
