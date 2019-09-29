# frozen_string_literal: true

require "test_helper"

class LocalesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should set locale" do
    assert_equal I18n.default_locale, I18n.locale
    # try set locale before log in
    post locale_path(locale: "de")
    assert_redirected_to root_path(locale: "de")
    follow_redirect!
    assert_equal "de", session["locale"]
    assert_equal :de, I18n.locale
    log_in_as(@user)
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_equal :en, I18n.locale
    # set local after log in
    post locale_path(locale: "de")
    assert_redirected_to root_path(locale: "de")
    assert_not flash[:success].empty?
    assert_equal "de", session["locale"]
    assert_equal :de, I18n.locale
  end
end
