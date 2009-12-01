require 'singleton'

module LogMaster
  class Configuration
    include Singleton
    
    attr_accessor :title, :reporting
    
    # These are options that directly affect the email
    attr_accessor :recipients, :from, :reply_to
    
    @@configured = false
    
    def initialize
      reset
    end
  
    def reset
      @title = "No Title"
      @reporting = {}
      
      @@configured = false
    end
  
    def self.configure
      yield instance
      @@configured = true
    end
    
    def self.configured?
      @@configured === true
    end
    
    # For testing purposes
    def reset_configured_status!
      @@configured = false
    end
  end
end