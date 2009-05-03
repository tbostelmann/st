class CreateInitialModel < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :owner_id
      t.string :owner_type
      t.integer :cents, :default => 0
      t.timestamps
    end

    create_table :financial_transactions do |t|
      t.integer :donation_id
      t.timestamps
    end

    create_table :line_items do |t|
      t.integer :cents
      t.boolean :debit
      t.integer :financial_transaction_id
      t.integer :account_id
      t.integer :donation_line_item_id
      t.timestamps
    end

    create_table :organizations do |t|
      t.string   :name
      t.timestamps
    end

    create_table :donations do |t|
      t.integer :user_id
      t.integer :saver_id
      t.string :donation_status, :default => Donation::STATUS_PENDING
      t.timestamps
    end
    
    create_table :donation_line_items do |t|
      t.integer :cents
      t.integer :donation_id
      t.string :description
      t.integer :account_id
      t.timestamps
    end

    create_table :payments do |t|
      t.string :account
      t.string :currency
      t.integer :gross
      t.integer :fee
      t.datetime :received_at
      t.string :status
      t.boolean :test
      t.string :transaction_id
      t.string :type
      t.integer :donation_id
      t.timestamps
    end

    add_column(:users, :saver, :boolean, :default => false)

    create_table :asset_types do |t|
      t.string :asset_name
      t.timestamps
    end

    create_table :asset_development_cases do |t|
      t.integer :user_id
      t.integer :organization_id
      t.integer :asset_type_id
      t.integer :requested_match_total_cents
      #t.integer :requested_match_left_cents
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
    remove_column(:users, :saver)
    drop_table :donation_line_items
    drop_table :donations
    drop_table :donation_statuses
    drop_table :assert_development_cases
    drop_table :asset_types
    drop_table :organizations
    drop_table :posts
    drop_table :financial_transactions
    drop_table :accounts
  end
end
