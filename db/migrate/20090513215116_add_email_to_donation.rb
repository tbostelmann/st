class AddEmailToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :notification_email, :string
  end

  def self.down
    remove_column :donations, :notification_email
  end
end
