require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogMaster
  describe "Configuration" do
    
    describe "configured?" do
      it "should be false if .confgure has not been called" do
        Configuration.instance.reset_configured_status!
        Configuration.should_not be_configured
      end
      
      it "should be false if .confgure has not been called" do
        Configuration.configure {|c|}
        Configuration.should be_configured
      end
    end
  end
end