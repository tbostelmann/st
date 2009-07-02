class DonorSurvey < ActiveRecord::Base
  belongs_to :donor

  validates_length_of :first_name, :in => 1..20, :allow_nil => false
  validates_length_of :last_name, :in => 1..20, :allow_nil => false
  validates_format_of :zip_code,
                    :with => %r{\d{5}(-\d{4})?},
                    :message => "should be 12345 or 12345-1234"
  validates_presence_of :zip_code
end
