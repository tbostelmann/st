class AddShowPyramidToDonor < ActiveRecord::Migration
  def self.up
    add_column :users, :show_pyramid, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_pyramid
  end
end
