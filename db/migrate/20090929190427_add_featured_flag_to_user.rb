class AddFeaturedFlagToUser < ActiveRecord::Migration
  def self.up
    add_column(:users, :featured_user, :boolean, :default => true)
  end

  def self.down
    remove_column(:users, :featured_user)
  end
end
