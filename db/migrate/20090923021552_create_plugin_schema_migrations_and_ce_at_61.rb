class CreatePluginSchemaMigrationsAndCeAt61 < ActiveRecord::Migration
  def self.up
    (1..61).each do |version|
      execute "insert into plugin_schema_migrations (plugin_name, version) VALUES('community_engine', #{version})"
    end
  end

  def self.down
  end
end
