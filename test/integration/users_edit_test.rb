# frozen_string_literal: true

require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@non_admin)
    get edit_user_path(@non_admin)
    assert_template "users/edit"
    patch user_path(@non_admin), params: { user: { name: "",
                                                   email: "foo@invalid",
                                                   password: "foo",
                                                   password_confirmation: "bar" } }

    assert_template "users/edit"
    assert_select "div.alert", "The form contains 5 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@non_admin)
    assert_redirected_to login_path
    follow_redirect!
    assert_template "user_sessions/new"
    assert_not_nil session[:forwarding_url]
    log_in_as(@non_admin)
    assert_redirected_to edit_user_path(@non_admin)
    name = "Foo Bar"
    email = "foo@bar.com"
    locale = "de"
    patch user_path(@non_admin), params: { user: { name: name,
                                                   email: email,
                                                   password: "",
                                                   password_confirmation: "",
                                                   locale: locale } }
    assert_not flash.empty?
    assert_redirected_to @non_admin
    assert_nil session[:forwarding_url]
    @non_admin.reload
    assert_equal name, @non_admin.name
    assert_equal email, @non_admin.email
    assert_equal locale, @non_admin.locale
  end
end
