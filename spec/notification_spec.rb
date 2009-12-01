require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogMaster
  describe "Notification email" do
    it "should be set to be delivered to success@example.com when successful" do
      email = Notifier.deliver_update_notification(true, {}, [])
      email.should deliver_to("success@example.com")
    end
    
    it "should be set to be delivered to success@example.com when failure" do
      email = Notifier.deliver_update_notification(false, {}, [])
      email.should deliver_to("failure@example.com")
    end

    describe "body" do
      it "should contain the title" do
        email = Notifier.deliver_update_notification(true, {}, [])
        email.should have_body_text(Configuration.instance.title)
      end
      
      it "should contain the aggregate report" do
        email = Notifier.deliver_update_notification(true, {:error => 1, :warn => 2, :fatal => 0}, [])
        email.should have_body_text(/Error:.*1/)
        email.should have_body_text(/Warn:.*2/)
        email.should have_body_text(/Fatal:.*0/)
      end
      
      it "should contain each of the provided logfiles" do
        log_1 = LogFile.new('log_without_errors.log')
        log_2 = LogFile.new('log_with_errors.log')
        email = Notifier.deliver_update_notification(true, {}, [log_1, log_2])
        
        log_1.body.each do |line|
          email.should have_body_text(line.chomp)
        end
        
        log_2.body.each do |line|
          email.should have_body_text(line.chomp)
        end
      end
      
      it "should warn that the file does not exist" do
        log_file = LogFile.new('fake_log.log')
        email = Notifier.deliver_update_notification(true, {}, [log_file])
        email.should have_body_text("File Missing")
      end
      
      it "should wrap lines in their respective classes" do
        log_file = LogFile.new(log_file_path('log_with_errors.log'), {:warn => /WARN/, :error => /ERROR/, :fatal => /FATAL/})
        email = Notifier.deliver_update_notification(true, {}, [log_file])
        email.should have_body_text(/class="error".*ERROR/)
        email.should have_body_text(/class="info".*Not an error/)
        email.should have_body_text(/class="fatal".*FATAL Oh Noes!/)
      end
    end
    
    describe "subject" do
      it "should contain successful message when successful" do
        email = Notifier.deliver_update_notification(true, {}, [])
        email.should have_subject(/SUCCESSFUL/)
      end
      
      it "should contain failure message when failure" do
        email = Notifier.deliver_update_notification(false, {}, [])
        email.should have_subject(/FAILED/)
      end
    end
  end
end