class CommunityEngineToVersion70 < ActiveRecord::Migration
  def self.up
    migrate_plugin(:community_engine, 70)  
  end

  def self.down
    migrate_plugin(:community_engine, 61)    
  end
end
