class CommunityEngineToVersion60 < ActiveRecord::Migration
  def self.up
    migrate_plugin(:community_engine, 60)
  end

  def self.down
    migrate_plugin(:community_engine, 0)    
  end
end
