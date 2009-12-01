module LogMaster
  class LogFile
    attr_accessor :file_path
  
    def initialize(file_path, reporting_configuration={})
      @file_path = file_path
      @reporting_configuration = reporting_configuration
    end
    
    def analyze
      reports = @reporting_configuration.keys.inject({}) {|h,l| h.merge(l => 0)}
      
      if log_file_exists?
        @reporting_configuration.each do |report_name, report_regexp|
          reports[report_name] = body.scan(report_regexp).size
        end
      end
      
      reports
    end
    
    def file_name
      File.basename(file_path)
    end
    
    def valid?
      log_file_exists?
    end

    def body
      log_file_exists? ? File.read(file_path) : "File Missing"
    end
  
    private
    def log_file_exists?
      File.exists?(file_path)
    end
  end
end