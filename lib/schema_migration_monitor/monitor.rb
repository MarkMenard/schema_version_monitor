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


require "active_record/connection_adapters/abstract/connection_pool"
puts "alias method chaining"
module ActiveRecord
  module ConnectionAdapters
    class ConnectionHandler
      def establish_connection_with_schema_migration_monitor(name, spec)
        original_result = establish_connection_without_schema_migration_monitor(name, spec)

        puts
        puts "Looks Like a connection is being established!"
        puts name
        puts spec.inspect
        puts

        original_result
      end
      
      alias_method_chain :establish_connection, :schema_migration_monitor
    end
  end
end
