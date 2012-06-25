require 'active_record'
require File.dirname(__FILE__) + '/migration_path_service'

module ActiveRecord
  module ConnectionAdapters
    class ConnectionHandler

      alias_method :old_establish_connection, :establish_connection

      def establish_connection(name, spec)
        result = old_establish_connection(name,spec)
        SchemaMigrationMonitor.new.execute
        result
      end

    end
  end
end


module SchemaMigrationMonitor
  class Monitor
    
    def initialize(output_stream = $stdout)
      @migration_path = MigrationPathService.execute
      @output_stream = output_stream
    end

    def execute
      pending_migrations = get_pending_migrations
      return if pending_migrations.empty?

      @output_stream.write("The following migration[s] need to be run #{pending_migrations.join(', ')}")
    end

    def get_pending_migrations
      ActiveRecord::Migrator.new(:up, @migration_path).pending_migrations
    end

  end
end