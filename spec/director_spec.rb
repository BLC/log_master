require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogMaster
  describe "Director" do
    before do
      Configuration.stub!(:configured?).and_return(true)
      @files = %w(log_without_errors.log log_with_errors.log).map {|f| log_file_path(f) }
    end
    
    it "should create a LogFile for each file given" do
      Director.new(@files).logs.size.should == @files.size
    end
    
    it "should raise error if not configured" do
      Configuration.stub!(:configured?).and_return(false)
      lambda {Director.new(@files)}.should raise_error
    end
  
    describe "aggregate" do
      it "should add the specs for all reports" do
        log_master = Director.new(@files)
        log_master.aggregate!
        log_master.reports[:error].should == 2
      end
    end
    
    describe "successful?" do
      it "should be true when no aggregate count for failure_conditions" do
        log_master = Director.new(log_file_path('log_without_errors.log'))
        log_master.run
        log_master.should be_successful
      end
      
      it "should be false when aggregate count for failure_conditions > 0" do
        log_master = Director.new(log_file_path('log_with_errors.log'))
        log_master.run
        log_master.should_not be_successful
      end
      
      it "should be false when given missing file" do
        log_master = Director.new(log_file_path('nosuchfile.log'))
        log_master.run
        log_master.should_not be_successful
      end
    end
  end
end