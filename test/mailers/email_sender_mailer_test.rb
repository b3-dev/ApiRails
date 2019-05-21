require 'test_helper'

class EmailSenderMailerTest < ActionMailer::TestCase
  test "complaintNewNotification" do
    mail = EmailSenderMailer.complaintNewNotification
    assert_equal "Complaintnewnotification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
