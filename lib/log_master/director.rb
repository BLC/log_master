require File.dirname(__FILE__) + "/../log_master"

module LogMaster
  class Director
  
    attr_accessor :reports, :logs
  
    def initialize(files)
      raise "LogMaster has not yet been configured" unless Configuration.configured?
      @configuration = Configuration.instance
      @reports = {}
      
      create_log_files(files)
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
    
    def successful?
      @configuration.failure_conditions.all? {|fc| @reports.fetch(fc, 0) == 0} && @logs.all? {|l| l.valid?}
    end
    
    def send_email
      Notifier.deliver_update_notification(successful?, @reports, @logs)
    end
    
    private
    def create_log_files(files)
      files = files.respond_to?(:each) ? files : [files]
      @logs = files.map { |f| LogFile.new(f, @configuration.reporting) }
    end
  end
end