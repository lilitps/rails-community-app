require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links without log in" do
    get root_path
    # header
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", root_path, text: "Home", count: 1
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", logout_path, count: 0
    # footer
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
  end

  test "page title without log in" do
    # header
    get root_path
    assert_select "title", full_title("")
    get login_path
    assert_select "title", full_title("Log in")
    get signup_path
    assert_select "title", full_title("Sign up")

    # footer
    get about_path
    assert_select "title", full_title("About")
    get contact_path
    assert_select "title", full_title("Contact")
    get help_path
    assert_select "title", full_title("Help")
  end

  test "layout links after log in" do
    user = users(:michael)
    log_in_as(user)
    get root_path
    # header
    assert_select "a[href=?]", login_path, count: 0
    # menu administration
    assert_select 'li.dropdown a.dropdown-toggle', 'Administration', count: 1
    assert_select "a[href=?]", users_path
    # menu account
    assert_select 'li.dropdown a.dropdown-toggle', 'Account', count: 1
    assert_select "a[href=?]", user_path(user)
    assert_select "a[href=?]", edit_user_path(user)
    assert_select "a[href=?]", logout_path
    # footer
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
  end

  test "page title after log in" do
    user = users(:michael)
    log_in_as(user)
    # menu administration
    get users_path
    assert_select "title", full_title("All users")
    # menu account
    get user_path(user)
    assert_select "title", full_title(user.name)
    get edit_user_path
    assert_select "title", full_title("Edit user")
  end
end
