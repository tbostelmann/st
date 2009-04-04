class Modifyusers < ActiveRecord::Migration
  def self.up
    #This should not be in the users model
    #add asset_type_id column to users model/table
    #execute "ALTER TABLE users add asset_type_id INT"
    #populate it with data
    #peopledata = {1=> {:asset_type_id=>'3'}, 2=>{:asset_type_id=>'1'}, 3=>{:asset_type_id=>'3'}, 4=>{:asset_type_id=>'2'}}	
    #User.update(peopledata.keys,peopledata.values)
  end

  def self.down
    remove_column :users, :asset_type_id
  end
end
