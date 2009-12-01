begin
  require 'actionmailer'
rescue LoadError
  warn 'To use LogMaster you need the actionmailer gem:'
  warn '$ sudo gem install actionmailer'
  raise
end

ActionMailer::Base.template_root = File.dirname(__FILE__) + "/templates"

require 'log_master/configuration'
require 'log_master/director'
require 'log_master/log_file'
require 'log_master/notifier'