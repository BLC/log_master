module LogMaster
  class Notifier < ActionMailer::Base
    helper_method :stylize_output
    
    def update_notification(status, reports, logs)
      @status = status
      @configuration = Configuration.instance
      
      subject       create_subject
      recipients    determine_recipients
      reply_to      @configuration.reply_to || @configuration.from
      from          @configuration.from
      content_type  "text/html"
      sent_on       Time.now
      body          :title => @configuration.title, :logs => logs, :reports => reports
    end

    def template_path
      File.expand_path(File.dirname(__FILE__) + "/../../templates/log_master/notifier/update_notification.html.erb")
    end
    
    def create_subject
      @configuration.title + (@status ? " SUCCESSFUL" : " FAILED")
    end
    
    def determine_recipients
      @status ? @configuration.recipients[:success] : @configuration.recipients[:failure]
    end
  
    protected
  
    def stylize_output(line)
      @configuration.reporting.each do |name, regexp|
        return name if line =~ regexp
      end
      
      "info"
    end
  end
end