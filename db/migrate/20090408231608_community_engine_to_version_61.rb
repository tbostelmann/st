class CommunityEngineToVersion61 < ActiveRecord::Migration
  def self.up
    migrate_plugin(:community_engine, 61)
  end

  def self.down
    migrate_plugin(:community_engine, 60)    
  end
end
