require 'spec_helper'
require 'pathname'

describe MigrationPathService do
  describe ".execute" do
    describe "when no .schema_migration_monitor config exists" do
      before(:each) do
        Pathname.expects(:new).with(MigrationPathService::USER_CONFIG_PATH).returns( mock(exist?:false) )
      end

      it "should verify a ./db/migrate directory exists" do
        # NOTE : This test passes when MigrationPathService.execute has no code !!!! Why?
        Pathname.expects(:new).with('./db/migrate').returns( mock(exist?:true) )
        MigrationPathService.execute
      end

      describe "when a ./db/migrate directory exists" do
        it "should return the string './db/migrate'" do
          Pathname.expects(:new).with('./db/migrate').returns( mock(exist?:true) )
          MigrationPathService.execute.should == './db/migrate'
        end
      end

      describe "when a ./db/migrate directory does not exist" do
        it "should raise an exception" do
          Pathname.expects(:new).with('./db/migrate').returns( mock(exist?:false) )

          expect do
            MigrationPathService.execute
          end.should raise_error(MigrationPathService::MigrationPathNotFoundError)
        end
      end
    end

    describe "when .schema_migration_monitor config exists" do
      let(:user_config_file_contents) do
        contents=<<-EOF
          migration_path: ./custom/migrate
        EOF
      end

      before(:each) do
        Pathname.expects(:new).with(MigrationPathService::USER_CONFIG_PATH).returns( mock(exist?:true) )
        MigrationPathService.expects(:user_config_file).returns(user_config_file_contents)
      end

      it "should return the path contained in the .schema_migration_monitor config" do
        MigrationPathService.execute.should == './custom/migrate'
      end
    end

  end
end