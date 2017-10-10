# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'user_sessions/new'
    post login_path, params: { user_session: { email: 'user@invalid', password: 'foo' } }
    assert_template 'user_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    log_in_as @user
    assert logged_in?
    assert_redirected_to @user
    assert flash.empty?
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    # Simulate a user clicking logout.
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_path
    # Simulate a user clicking logout in a second window.
    delete logout_path
    assert_redirected_to login_path
    assert_not flash.empty?
    assert flash[:notice] == 'Please log in.'
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path,      count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')
    assert logged_in?
    assert @current_user_session.remember_me?
  end

  test 'login without remembering' do
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: 'false')
    assert logged_in?
    assert_not @current_user_session.remember_me?
  end

  test 'logged in user should get notice after another login try' do
    log_in_as(@user)
    assert logged_in?
    log_in_as(@user)
    assert logged_in?
    assert_redirected_to root_path
    assert_not flash.empty?
    assert flash[:notice] == 'Please log out.'
  end
end
