class CreateInitialModel < ActiveRecord::Migration
  def self.up
    create_table :invoices, :options => "auto_increment = #{Time.now.to_i}" do |t|
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
      t.string :status, :default => LineItem::STATUS_PENDING
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
    add_column(:users, :first_name, :string)
    add_column(:users, :last_name, :string)
    add_column(:users, :web_site_url, :string)
    add_column(:users, :phone_number, :string)

    create_table :payment_notifications do |t|
      t.text :raw_data
      t.timestamps
    end

    create_table :organization_surveys do |t|
      t.integer :organization_id
      t.string :year_founded
      t.string :annual_operating_expenses
      t.integer :total_matched_accounts
      t.string :year_first_accounts_opened
      t.integer :last_year_number_of_accounts
      t.integer :number_of_active_accounts
      t.string :attrition_rate
      t.string :household_income_eligibility
      t.timestamps
    end
  end

  def self.down
    drop_table :organization_surveys
    drop_table :payment_notifications
    remove_column(:users, :full_name)
    remove_column(:users, :last_name)
    remove_column(:users, :first_name)
    remove_column(:users, :organization_id)
    remove_column(:users, :asset_type_id)
    remove_column(:users, :requested_match_cents)
    remove_column(:users, :type)
    drop_table :asset_types
    drop_table :line_items
    drop_table :invoices
   end
end
