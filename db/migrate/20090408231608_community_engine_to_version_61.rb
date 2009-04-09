class CommunityEngineToVersion61 < ActiveRecord::Migration
  def self.up
    Engines.plugins["community_engine"].migrate(61)
  end

  def self.down
    Engines.plugins["community_engine"].migrate(60)
  end
end
