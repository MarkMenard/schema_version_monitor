require 'pathname'

class MigrationPathService

  DEFAULT_MIGRATION_PATH = './db/migrate'
  USER_CONFIG_PATH = '.schema_migration_monitor.yml'

  class MigrationPathNotFoundError < StandardError; end

  class << self
    def execute
      return get_user_config_path if Pathname.new(USER_CONFIG_PATH).exist?
      return DEFAULT_MIGRATION_PATH if Pathname.new(DEFAULT_MIGRATION_PATH).exist?
      raise MigrationPathNotFoundError
    end

    def get_user_config_path
      YAML::load(user_config_file)['migration_path']
    end

    def user_config_file
      File.open(USER_CONFIG_PATH)
    end
  end
end

