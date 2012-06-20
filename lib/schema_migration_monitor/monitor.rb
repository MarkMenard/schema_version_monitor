module SchemaMigrationMonitor
  class ConfigFileException < StandardError; end

  class SchemaMigrationMonitor


    attr_accessor :environment
    def initialize
      @environment = YAML::readstuff
    end

    def execute
    end
  end
end


__END__
ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql',
  :database => 'database',
  :username => 'user',
  :password => 'password',
  :host     => 'localhost')

require 'rubygems'
require 'active_record'
require 'yaml'

dbconfig = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)

migrator = ActiveRecord::Migrator.new(:up, Rails.root.join('db','migrate'))
migrator.pending_migrations
