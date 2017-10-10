# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }

    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 5 errors.'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'user_sessions/new'
    assert_not_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    name = 'Foo Bar'
    email = 'foo@bar.com'
    locale = 'de'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '',
                                              locale: locale } }
    assert_not flash.empty?
    assert_redirected_to @user
    assert_nil session[:forwarding_url]
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert_equal locale, @user.locale
  end
end
