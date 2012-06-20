class EnvironmentLoaderService
  
  def execute

  end
  
  def load_schema_migration_monitor
    YAML::load(File.open('./.schema_migration_monitor.yml'))
  end

  # database-config:
  #   file: 'config/database.yml'
  #   test: 'test'
  #   production: 'production'

  def load_config_database_yml
    YAML::load(File.open('config/database.yml'))
  end

end