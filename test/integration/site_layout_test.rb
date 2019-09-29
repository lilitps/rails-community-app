# frozen_string_literal: true

require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links when not logged in" do
    get root_path
    # header
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, count: 2
    assert_select ".navbar-brand", count: 2
    assert_select "a[href=?]", root_path, text: "Home", count: 1
    assert_select "a[href=?]", root_path + "#news", text: "News", count: 1
    assert_select "#news", count: 1
    assert_select "a[href=?]", root_path + "#membership",
                  text: "Membership", count: 1
    assert_select "#membership", count: 1
    # partner
    assert_select "#partner-austria", count: 1
    assert_select "#partner-wildlife-park", count: 1
    assert_select "#partner-clubs", count: 1
    assert_select "a[href=?]", root_path + "#consultation",
                  text: "Telescopic Consultations", count: 1
    assert_select "#consultation", count: 1
    assert_select "a[href=?]", root_path + "#contact",
                  text: "Contact", count: 1
    assert_select "#contact", count: 1
    assert_select "a[href=?]", root_path + "#directions",
                  text: "Directions", count: 1
    assert_select "#directions", count: 1
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", signup_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    # menu Language
    assert_select "div#language-dropdown.a.nav-link.dropdown-toggle", "Language"
    assert_select "a[href=?]", locale_path(locale: "en"), text: "English"
    assert_select "a[href=?]", locale_path(locale: "de"), text: "Deutsch"

    # footer
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", imprint_path

    # no menu for account and administration
    assert_select ".a.nav-link.dropdown-toggle", count: 1
  end

  test "page title when not logged in" do
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
    get imprint_path
    assert_select "title", full_title("Imprint")
  end

  test "layout links when logged in" do
    user = users(:michael)
    log_in_as(user)
    get root_path
    # header
    assert_select "a[href=?]", login_path, count: 0
    # menu account
    assert_select "li.nav-item.dropdown>.a.nav-link.dropdown-toggle", "Account"
    assert_select "a[href=?]", user_path(user)
    assert_select "a[href=?]", edit_user_path(user)
    assert_select "a[href=?]", logout_path

    # footer
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", imprint_path

    # no menu for administration
    assert_select ".a.nav-link.dropdown-toggle", count: 2
  end

  test "page title when logged in" do
    user = users(:lana)
    log_in_as(user)
    # menu account
    get user_path(user)
    assert_select "title", full_title(user.name)
    get edit_user_path
    assert_select "title", full_title("Edit user")
    # relationships
    get following_user_path(user)
    assert_select "title", full_title("Following")
    get followers_user_path(user)
    assert_select "title", full_title("Followers")
  end

  test "layout links when logged in as admin" do
    user = users(:lana)
    log_in_as(user)
    get root_path
    # header
    assert_select "a[href=?]", login_path, count: 0

    # footer
    # menu administration
    assert_select "li.nav-item.dropdown>.a.nav-link.dropdown-toggle",
                  "Administration"
    assert_select "a[href=?]", users_path

    # all menus and posts menus active
    assert_select ".a.dropdown-toggle", count: 6
    assert_select ".a.nav-link.dropdown-toggle", count: 3
  end
end
