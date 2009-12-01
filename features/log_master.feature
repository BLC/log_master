Feature: Sending emails
  Scenario: LogMaster sends an email to
    Given I have configured LogMaster like:
    When I run LogMaster on a file with errors
    Then I should 
