class AddDonorSurveyValues < ActiveRecord::Migration
  def self.up
    add_column(:donor_surveys, :first_name, :string)
    add_column(:donor_surveys, :last_name, :string)
    add_column(:donor_surveys, :zip_code, :string)
  end

  def self.down
    remove_column(:donor_surveys, :first_name)
    remove_column(:donor_surveys, :last_name)
    remove_column(:donor_surveys, :zip_code)
  end
end
