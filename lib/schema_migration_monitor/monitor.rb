require 'active_record'
require File.dirname(__FILE__) + '/migration_path_service'

module ActiveRecord
  module ConnectionAdapters
    class ConnectionHandler

      alias_method :establish_connection_without_monitor, :establish_connection

      def establish_connection(name, spec)
        result = establish_connection_without_monitor(name,spec)
        SchemaMigrationMonitor::Monitor.new.execute
        result
      end

    end
  end
end


# make a nice output for testing
# **************************************
# ** This is an example of the output **
# ** It's multi-line too!             **
# **************************************
def star_puts(*args)
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
      text_lines = prompt_user_text.split("\n")

      longest_line = text_lines.inject(0) do |memo, arg|
        ll = arg.to_s.length
        memo = ll if ll > memo
        memo
      end

      @output_stream.write("\e[1;31m\n")
      @output_stream.write("*" * (longest_line + 6) + "\n")
      text_lines.each do |line|
        @output_stream.write "** #{line}#{ " " * (longest_line - line.to_s.length) } **\n"
      end
      @output_stream.write("*" * (longest_line + 6) + "\n")
      @output_stream.write("\n\e[0m")      
    end

    def prompt_user_text
      res = "The following migration(s) need to be run:"
      res << @pending_migrations.map { |migration| "\n  - #{migration.filename}" }.join
      #res << "\nWould you like to run these migrations now? [Y/N]"
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