# frozen_string_literal: true

require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "ul.pagination-sm", count: 2
    first_page_of_users = assigns(:users)
    assert_not first_page_of_users.empty?
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select "a[href=?]", user_path(user), text: "delete" unless user == @admin
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    get users_path
    assert_redirected_to login_path
    log_in_as(@non_admin)
    get users_path
    assert_redirected_to root_path
    assert_not flash.empty?
    assert flash[:notice] == "You are not authorized to access this page."
  end
end
