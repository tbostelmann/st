class CreateInitialModel < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :donor_id
      t.string :type
      t.string :notification_email
      t.timestamps
    end

    create_table :line_items do |t|
      t.integer :cents
      t.integer :invoice_id
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :status
      t.string :type
      t.timestamps
    end

    create_table :asset_types do |t|
      t.string :asset_name
      t.timestamps
    end

    add_column(:users, :type, :string)
    add_column(:users, :requested_match_cents, :integer)
    add_column(:users, :asset_type_id, :integer)
    add_column(:users, :organization_id, :integer)
    add_column(:users, :full_name, :string)

    create_table :payment_notifications do |t|
      t.text :raw_data
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_notifications
    remove_column(:users, :full_name)
    remove_column(:users, :organization_id)
    remove_column(:users, :asset_type_id)
    remove_column(:users, :requested_match_cents)
    remove_column(:users, :type)
    drop_table :asset_types
    drop_table :line_items
    drop_table :invoices
   end
end
