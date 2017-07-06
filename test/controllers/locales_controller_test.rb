require 'test_helper'

class LocalesControllerTest < ActionDispatch::IntegrationTest
  test "should set locale" do
    assert_equal I18n.default_locale, I18n.locale
    post locale_path(locale: 'de')
    assert_redirected_to root_url(locale: 'de')
    assert_not flash[:success].empty?
    assert_equal 'de', session['locale']
    assert_equal :de, I18n.locale
  end
end
