class RemoveLineItemStatusDefaultValue < ActiveRecord::Migration
  def self.up
    execute "alter table line_items alter status drop default"
    execute "update line_items set status = null where status = 'Pending'"
  end

  def self.down
    execute "update line_items set status = 'Pending' where status is null"
    execute "alter table line_items alter status set default 'Pending'"
  end
end
