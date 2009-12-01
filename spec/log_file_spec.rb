require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogMaster
  describe "LogFile" do
    before(:all) do
      @log_with_errors_path = log_file_path("log_with_errors.log")
      @log_without_errors_path = log_file_path("log_without_errors.log")
    end
    
    describe "analyze!" do
      it "should count the number of errors in the file according to provided regexp" do
        log_file = LogFile.new(@log_with_errors_path, {:error => /ERROR/ })
        log_file.analyze[:error].should == 2
      end
    
      it "should find no errors in provided file" do
        log_file = LogFile.new(@log_without_errors_path, {:error => /ERROR/ })
        log_file.analyze[:error].should be_zero
      end
    end
  
    describe "valid?" do
      it "should be true if file present and no other conditions on validity" do
        log_file = LogFile.new(@log_without_errors_path)
        log_file.should be_valid      
      end
    
      it "should be false when file is absent" do
        log_file = LogFile.new('log_that_does_not_exist.log')
        log_file.should_not be_valid
      end
    end
    
    describe "body" do
      it "should be 'File Missing' if file does not exist" do
        LogFile.new('log_that_does_not_exist.log').body.should == "File Missing"
      end
      
      it "should be the log's data" do
        LogFile.new(@log_without_errors_path).body.should == File.read(FIXTURES_DIR + "/log_without_errors.log")
      end
    end 
  end
end