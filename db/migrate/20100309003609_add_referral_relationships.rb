class AddReferralRelationships < ActiveRecord::Migration
  def self.up
    add_column :users, :referred_by_donor_id, :integer
  end

  def self.down
    remove_column :users, :referred_by_donor_id
  end
end
