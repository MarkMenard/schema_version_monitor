require 'active_record'
require File.dirname(__FILE__) + '/migration_path_service'

module ActiveRecord
  module ConnectionAdapters
    class ConnectionHandler

      alias_method :establish_connection_without_monitor, :establish_connection

      def establish_connection(name, spec)
        result = establish_connection_without_monitor(name,spec)
        monitor_migrations
        result
      end

      def monitor_migrations
        SchemaMigrationMonitor::Monitor.new.execute
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
      output_report
    end

    def output_report
      write_boxed_output(report_text.split("\n"))
    end

    def report_text
      res = "The following migration(s) need to be run:"
      res << @pending_migrations.map { |migration| "\n  - #{migration.filename}" }.join
    end

    def write_boxed_output(text_lines)
      longest_line = get_longest_line(text_lines)

      wrap_output_in_red do
        @output_stream.write("*" * (longest_line + 6) + "\n")

        text_lines.each do |line|
          @output_stream.write "** #{line}#{ " " * (longest_line - line.to_s.length) } **\n"
        end

        @output_stream.write("*" * (longest_line + 6) + "\n")
      end
    end

    def wrap_output_in_red
      @output_stream.write("\e[1;31m\n")
      yield if block_given?
      @output_stream.write("\n\e[0m") 
    end

    def get_longest_line(text_lines)
      text_lines.inject(0) do |memo, arg|
        line_length = arg.to_s.length
        memo = line_length if line_length > memo
        memo
      end
    end

    def get_pending_migrations
      migrator.pending_migrations
    end

    def migrator
      @migrator ||= ActiveRecord::Migrator.new(:up, @migration_path)
    end

  end
end