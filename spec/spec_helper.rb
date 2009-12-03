$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'

# Explicitly required so we can set class vars before Notifier gets loaded
require 'action_mailer'

# ActionMailer::Base.template_root = File.dirname(__FILE__) + "/../lib/templates"
ActionMailer::Base.delivery_method = :test
# ActionMailer::Base.logger = Logger.new('test.log')

require 'log_master'
require 'spec'
require 'spec/autorun'

require "email_spec"
require "email_spec/helpers"
require "email_spec/matchers"

require File.dirname(__FILE__) + '/../lib/log_master'

FIXTURES_DIR = File.dirname(__FILE__) + "/fixtures"

LogMaster::Configuration.configure do |config|
  config.title = "Testing LogMaster"
  config.reporting = {:warn => /WARN/, :error => /ERROR/, :fatal => /FATAL/}
  config.failure_conditions = [:error, :fatal]
  config.recipients = {:success => "success@example.com", :failure => "failure@example.com"}
end

Spec::Runner.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end

def log_file_path(path)
  File.join(FIXTURES_DIR, path)
end