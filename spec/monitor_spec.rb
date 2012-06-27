require 'spec_helper'

describe SchemaMigrationMonitor::Monitor do
  before(:each) do
    MigrationPathService.stubs(:execute).returns(MigrationPathService::DEFAULT_MIGRATION_PATH)
  end

  describe "when ActiveRecord establishes a connection" do
    it "should also execute the schema migration monitor" do
      SchemaMigrationMonitor::Monitor.expects(:new).returns(mock(execute: nil))
      ActiveRecord::Base.establish_connection({:adapter => 'sqlite3', database: ":memory:"})
    end
  end

  describe "when there are no pending migrations" do
    let!(:mock_migrator) do
      mock('migrator').tap do |migrator|
        migrator.expects(:pending_migrations).returns([])
      end
    end

    before(:each) do
      SchemaMigrationMonitor::Monitor.any_instance.expects(:migrator).returns(mock_migrator)
    end

    it "should do nothing" do
      output_stream = mock('output_stream')
      output_stream.expects(:write).never
      SchemaMigrationMonitor::Monitor.new(output_stream).execute
    end
  end

  describe "when there are pending migrations" do
    let(:migrations) { [mock('migration1', filename:'20120101000000_fake_migration')] }

    let!(:mock_migrator) do
      mock('migrator').tap do |migrator|
        migrator.expects(:pending_migrations).returns(migrations)
      end
    end

    before(:each) do
      SchemaMigrationMonitor::Monitor.any_instance.expects(:migrator).returns(mock_migrator)
    end
        
    it "should print a message to stdout" do
      read_io, write_io = IO.pipe
      SchemaMigrationMonitor::Monitor.new(write_io).execute
      write_io.close_write
      read_io.read.should match(/The following migration\(s\) need to be run/)
    end
  end

end