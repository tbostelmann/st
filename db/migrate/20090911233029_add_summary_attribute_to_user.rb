class AddSummaryAttributeToUser < ActiveRecord::Migration
  def self.up
    add_column(:users, :short_description, :string)
  end

  def self.down
    remove_column(:users, :short_description)
  end
end
