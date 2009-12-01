namespace :log_master do
  task :configure do
    require 'actionmailer'
    ActionMailer::Base.delivery_method = :sendmail
    
    LogMaster::Configuration.configure do |config|
      config.title = "This is a sample email"
      config.recipients = {:success => 'localhost', :failure => 'localhost' }
      config.reporting = {:warn => /WARN/, :error => /ERROR/, :fatal => /FATAL/}
      config.reply_to = "sender@example.com"
    end
  end
  
  desc "Runs log master on specified log file"
  LogMaster::Rake::LogTask.define_task "test" => :configure do |t|
    t.log_file = "spec/fixtures/log_with_errors.log"
  end
end