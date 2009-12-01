require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogMaster
  describe "Director" do
    before do
      @files = %w(log_without_errors.log log_with_errors.log).map {|f| log_file_path(f) }
    end
    
    it "should create a LogFile for each file given" do
      Director.new(@files).logs.size.should == @files.size
    end
    
    it "should raise error if not configured" do
      Configuration.instance.reset_configured_status!
      lambda {Director.new(@files)}.should raise_error
      Configuration.configure {|c|} # Reset configured state
    end
  
    describe "aggregate" do
      it "should add the specs for all reports" do
        log_master = Director.new(@files)
        log_master.aggregate!
        log_master.reports[:error].should == 2
      end
    end
  end
end