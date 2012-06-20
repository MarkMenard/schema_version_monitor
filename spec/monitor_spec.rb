require 'spec_helper'

describe SchemaMigrationMonitor::Monitor do
  it "should attempt to read a ./.schema_migration_monitor file upon initialization" do
    
    SchemaMigrationMonitor.any_instance.stubs(:load_config_database_yml).returns()

    monitor = SchemaMigrationMonitor::Monitor.new
    monitor.environment.should be something
  end

  describe "when a ./.schema_migration_monitor file does not exist" do

    describe "and a ./config/database.yml does not exist" do
      it "should raise an exception" do
        expect { SchemaMigrationMonitor::Monitor.new }.to raise_error(SchemaMigrationMonitor::ConfigFileException)
      end
    end

    describe "and a ./config/database.yml does exist" do
      it "should use the ./config/database.yml file" do

      end
    end


  end

  describe "when a ./.schema_migration_monitor file does exist" do
  end
end