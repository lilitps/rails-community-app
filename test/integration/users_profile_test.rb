require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin = users(:lana)
    @user = users(:michael)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'section.user_info>a>img.gravatar'
  end

  test "post sidebar count" do
    log_in_as(@admin)
    get user_path(@admin)
    assert_template 'users/show'
    assert_match "#{@admin.posts.count} posts", response.body
    # Admin user with zero posts
    other_admin_user = users(:malory)
    log_in_as(other_admin_user)
    get user_path(other_admin_user)
    assert_match "0 posts", response.body
    other_admin_user.posts.create!(content: "A post")
    get user_path(other_admin_user)
    assert_match "#{other_admin_user.posts.count} post", response.body
  end
end
