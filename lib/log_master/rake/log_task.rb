require 'log_master'

module LogMaster
  module Rake    
    class LogTask < ::Rake::Task
      attr_accessor :log_pattern
      
      protected
      def execute(*args)
        super
        run_log_master
      end
    
      def run_log_master
        files = Dir[log_pattern]
        LogMaster::Director.new(files).run
      end
    end
  end
end