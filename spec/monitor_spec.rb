require 'spec_helper'

describe SchemaMigrationMonitor::Monitor do

  before(:each) do
    MigrationPathService.expects(:execute).returns(MigrationPathService::DEFAULT_MIGRATION_PATH)
  end

  # describe "when ActiveRecord establishes a connection" do
  #   it "should execute the schema migration monitor" do
  #     SchemaMigrationMonitor::Monitor.expects(new: nil, execute: nil)
  #     ActiveRecord::ConnectionAdapters::ConnectionHandler.stubs(:establish_connection_without_monitor)
      
  #     ActiveRecord::Base.establish_connection({:adapter => :asdf})
  #   end
  # end

  it "should check the pending migrations" do
    get_migrator_with_pending_migrations([])
    SchemaMigrationMonitor::Monitor.new.execute
  end

  describe "when there are no pending migrations" do
    before(:each) do
      get_migrator_with_pending_migrations([])
    end

    it "should do nothing" do
      output_stream = get_output_stream_mock
      output_stream.should_receive(:write).exactly(0).times
      SchemaMigrationMonitor::Monitor.new(output_stream).execute
    end
  end

  describe "when there are pending migrations" do
    let(:migrations) { [mock('migration1', filename:'20120101000000_fake_migration')] }

    before(:each) do
      get_migrator_with_pending_migrations(migrations)
    end

    let(:output_stream) do
      result = String.new
      def result.write(arg)
        self << arg
      end
      result
    end
        
    it "should print a message to stdout" do
      SchemaMigrationMonitor::Monitor.new(output_stream).execute
      (output_stream =~ /The following migration\(s\) need to be run/).should_not == nil
    end
  end


  def get_migrator_with_pending_migrations(pending_migrations)
    mock_migrator = mock('migrator') 
    mock_migrator.expects(:pending_migrations).returns(pending_migrations)
    ActiveRecord::Migrator.expects(:new).returns(mock_migrator)
    mock_migrator
  end

  def get_output_stream_mock
    mock('output_stream')
  end

end