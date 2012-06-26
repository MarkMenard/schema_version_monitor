require 'active_record'
require File.dirname(__FILE__) + '/migration_path_service'

module ActiveRecord
  module ConnectionAdapters
    class ConnectionHandler

      alias_method :old_establish_connection, :establish_connection

      def establish_connection(name, spec)
        result = old_establish_connection(name,spec)
        SchemaMigrationMonitor::Monitor.new.execute
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
      @pending_migrations = get_pending_migrations
      return if @pending_migrations.empty?
      prompt_user
    end

    def prompt_user
      @output_stream.write(prompt_user_text)
    end

    def prompt_user_text
      res = "The following migration[s] need to be run:"
      res << @pending_migrations.map { |migration| "\n  - #{migration}" }.join
      res << "\nWould you like to run these migrations now? [Y/N]"
      res
    end

    def get_pending_migrations
      migrator.pending_migrations
    end

    def migrator
      @migrator ||= ActiveRecord::Migrator.new(:up, @migration_path)
    end

  end
end