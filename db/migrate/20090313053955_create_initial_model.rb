class CreateInitialModel < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :owner_id
      t.string :owner_type
      t.timestamps
    end

    create_table :organizations do |t|
      t.string   :name
      t.timestamps
    end

    create_table :asset_development_cases do |t|
      t.integer :user_id
      t.integer :organization_id
      t.timestamps
    end

    create_table :donations do |t|
      t.integer :user_id
      t.timestamps
    end
    
    create_table :donation_line_items do |t|
      t.integer :cents
      t.integer :donation_id
      t.string :description
      t.integer :account_id
      t.timestamps
    end

    add_column(:users, :saver, :boolean, :default => false)  
  end

  def self.down
    remove_column(:users, :saver)
    drop_table :donation_line_items
    drop_table :donations
    drop_table :assert_development_cases
    drop_table :organizations
    drop_table :accounts
  end
end
