require 'log_master'

module LogMaster
  module Rake    
    class LogTask < ::Rake::Task
      attr_accessor :log_file
      
      protected
      def execute(*args)
        super
        run_log_master
      end
    
      def run_log_master
        LogMaster::Director.new(log_file).run
      end
    end
  end
end