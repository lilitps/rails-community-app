# frozen_string_literal: true

require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test 'contact the community' do
    user = users(:michael)
    @contact = Contact.new name: user.name,
                           email: user.email,
                           subject: 'subject',
                           message: 'message'
    mail = ContactMailer.contact(@contact)
    assert_equal ['kontakt@sifez.de'], mail.to
    assert_equal [user.email], mail.reply_to
    assert_equal [user.email], mail.from
    assert_equal 'Contact message from ' + user.email + ': ' + @contact.subject, mail.subject
    assert_match @contact.message, mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match user.email, mail.body.encoded
  end
end
