require File.dirname(__FILE__) + "/../log_master"

module LogMaster
  class Director
  
    attr_accessor :reports, :logs
  
    def initialize(files)
      raise "LogMaster has not yet been configured" unless Configuration.configured?
      
      create_log_files(files)
      @reports = {}
    end
    
    def run
      aggregate!
      send_email
    end
  
    def aggregate!
      logs.each do |l|
        l.analyze.each do |name, value|
          @reports[name] ||= 0
          @reports[name] += value
        end
      end
    end
    
    def status
      @reports[:fatal] == 0 && @reports[:error] == 0
    end
    
    def send_email
      Notifier.deliver_update_notification(status, @reports, @logs)
    end
    
    private
    def create_log_files(files)
      files = files.respond_to?(:each) ? files : [files]
      @logs = files.map { |f| LogFile.new(f, Configuration.instance.reporting) }
    end
  end
end