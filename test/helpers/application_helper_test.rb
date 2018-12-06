# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, I18n.t('community.name')
    assert_equal full_title('Help'), 'Help | ' + I18n.t('community.name')
  end

  test 'check the expiry date' do
    ENV['IDEALO_CONSULTATION_EXPIRY_DATE'] = '2016-12-31'
    assert expiry_date_past?
    ENV['IDEALO_CONSULTATION_EXPIRY_DATE'] = Date.current.to_s
    assert_not expiry_date_past?
    ENV['IDEALO_CONSULTATION_EXPIRY_DATE'] = (Date.current + 2.years).to_s
    assert_not expiry_date_past?
  end

  test 'mail to link helper' do
    mailto = ENV['CONTACT_MAIL_TO']
    page_title = I18n.t('page_title.imprint')
    community_name = I18n.t('community.name')
    subject = ERB::Util.u "#{page_title} #{community_name}"

    assert_equal mail_to_community, "<a href=\"mailto:#{mailto}?subject=#{subject}\">#{mailto}</a>"
  end
end
