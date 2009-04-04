class CreateAssetTypes < ActiveRecord::Migration
  def self.up
    create_table :asset_types do |t|
      t.string :asset_name
      t.timestamps
    end

    # seed initial asset types
    AssetType.create :asset_name => "education"
    AssetType.create :asset_name => "home"
    AssetType.create :asset_name => "business"

    #add column to asset_development_cases table with foreign key constraint 
    execute "ALTER TABLE asset_development_cases ADD asset_type_id INT NOT NULL DEFAULT 1"
    execute "ALTER TABLE asset_development_cases ADD FOREIGN KEY (asset_type_id) REFERENCES asset_types(id)" 

    peopledata = { 1=>{:asset_type_id => '1'}, 2=> {:asset_type_id => '2'}, 3=>{:asset_type_id=> '3'}, 4=>{:asset_type_id=>'2'} }
   AssetDevelopmentCase.update(peopledata.keys,peopledata.values)
  end

  def self.down
    remove_column :asset_development_cases, :asset_type_id
    drop_tables :asset_types
  end

end
