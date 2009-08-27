# == Schema Information
# Schema version: 20090701201617
#
# Table name: organization_surveys
#
#  id                         :integer(4)      not null, primary key
#  organization_id            :integer(4)
#  contact_email              :string(255)
#  year_founded               :string(255)
#  annual_operating_expenses  :string(255)
#  total_matched_accounts     :integer(4)
#  year_first_accounts_opened :string(255)
#  number_of_active_accounts  :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#

class OrganizationSurvey < ActiveRecord::Base
  belongs_to :organization
end
