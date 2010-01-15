require File.dirname(__FILE__) + "/../log_master"

module LogMaster
  class Director
  
    attr_accessor :reports, :logs
  
    def self.execute(files, options={})
      new(files, options).run
    end
  
    def initialize(files, options={})
      @options = options
      @options[:file]       ||= 'config/log_master.rb'
      
      @reports = {}
      
      load_configuration
      create_log_files(files)
    end
    
    def run
      aggregate!
      send_email
    end
    
    def load_configuration
      require @options[:file] if File.exists?(@options[:file])
    
      # config = File.read(@options[:file])
      # eval(config)
      
      if Configuration.configured?
        @configuration = Configuration.instance
      else
        raise "[fail] LogMaster is not configured"
      end
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