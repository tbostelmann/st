class CommunityEngineToVersion60 < ActiveRecord::Migration
  def self.up
    Engines.plugins["community_engine"].migrate(60)
  end

  def self.down
    Engines.plugins["community_engine"].migrate(55)
  end
end
