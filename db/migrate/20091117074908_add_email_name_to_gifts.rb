class AddEmailNameToGifts < ActiveRecord::Migration
  def self.up
    create_table :gift_cards do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :message
      t.integer :line_item_from_id
      t.integer :line_item_to_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :gift_cards
  end
end
