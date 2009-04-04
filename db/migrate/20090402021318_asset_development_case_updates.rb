class AssetDevelopmentCaseUpdates < ActiveRecord::Migration
  def self.up
    add_column :asset_development_cases, :requested_match_total, :decimal, {:precision=>6, :scale=>2, :default=>'0.00', :null=> false}
    add_column :asset_development_cases, :requested_match_left, :decimal, {:precision=>6, :scale=>2, :default=>'0.00', :null=> false}
  end

  def self.down
    remove_column :asset_development_cases, :requested_match_total
    remove_column :asset_development_cases, :requested_match_left
  end
end
