# == Schema Information
# Schema version: 20090701201617
#
# Table name: donor_surveys
#
#  id                      :integer(4)      not null, primary key
#  donor_id                :integer(4)
#  add_me_to_cfed_petition :boolean(1)
#  first_name              :string(255)
#  last_name               :string(255)
#  zip_code                :string(255)
#

class DonorSurvey < ActiveRecord::Base
  belongs_to :donor

  validates_length_of :first_name, :in => 1..20, :allow_nil => false
  validates_length_of :last_name, :in => 1..20, :allow_nil => false
  validates_format_of :zip_code,
                    :with => %r{\d{5}(-\d{4})?},
                    :message => "should be 12345 or 12345-1234"
  validates_presence_of :zip_code
end
