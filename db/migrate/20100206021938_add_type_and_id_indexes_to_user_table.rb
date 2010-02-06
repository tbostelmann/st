class AddTypeAndIdIndexesToUserTable < ActiveRecord::Migration
  def self.up
    add_index :users, :type, :name => "index_users_on_type"
    add_index :users, :id, :name => "index_users_on_id"
  end

  def self.down
    remove_index :users, :type
    remove_index :users, :id
  end
end
