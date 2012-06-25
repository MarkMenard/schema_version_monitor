require 'spec_helper'

describe SchemaMigrationMonitor::Monitor do

  before(:each) do
    MigrationPathService.expects(:execute).returns(MigrationPathService::DEFAULT_MIGRATION_PATH)
  end

  it "should check the pending migrations" do
    get_migrator_with_pending_migrations([])
    SchemaMigrationMonitor::Monitor.new.execute
  end

  describe "when there are no pending migrations" do
    it "should do nothing" do
      output_stream = get_output_stream_mock
      output_stream.should_receive(:write).exactly(0).times
      get_migrator_with_pending_migrations([])
      SchemaMigrationMonitor::Monitor.new(output_stream).execute
    end
  end

  describe "when there are pending migrations" do
    before(:each) do
      get_migrator_with_pending_migrations(['20120101000000_fake_migration', '20120101000001_fake_migration_2'])
    end
    it "should print a message to stdout" do
      output_stream = get_output_stream_mock
      output_stream.expects(:write).with('The following migration[s] need to be run 20120101000000_fake_migration, 20120101000001_fake_migration_2')
      SchemaMigrationMonitor::Monitor.new(output_stream).execute
    end
  end

  def get_migrator_with_pending_migrations(pending_migrations)
    mock_migrator = mock('migrator') 
    mock_migrator.expects(:pending_migrations).returns(pending_migrations)
    ActiveRecord::Migrator.expects(:new).returns(mock_migrator)
  end

  def get_output_stream_mock
    stdout_mock = mock('output_stream')
    stdout_mock.stubs(:write)
    stdout_mock
  end

end