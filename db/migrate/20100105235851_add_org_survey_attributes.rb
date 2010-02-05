class AddOrgSurveyAttributes < ActiveRecord::Migration
  def self.up
    add_column(:organization_surveys, :location_state, :string)
    add_column(:organization_surveys, :location_city, :string)
  end

  def self.down
    remove_column(:organization_surveys, :location_state)
    remove_column(:organization_surveys, :location_city)
  end
end
