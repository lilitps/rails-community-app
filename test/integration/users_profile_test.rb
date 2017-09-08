# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin = users(:lana)
    @user = users(:michael)
  end

  test 'profile display' do
    log_in_as(@admin)
    get user_path(@admin)
    assert_template 'users/show'
    assert_select 'title', full_title(@admin.name)
    assert_select 'h1', text: @admin.name
    assert_select 'section.user_info>a>img.gravatar'
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'section.user_info>a>img.gravatar'
  end

  test 'post sidebar count' do
    log_in_as(@admin)
    get user_path(@admin)
    assert_template 'users/show'
    assert_match "#{@admin.posts.count} posts", response.body
    # Admin user with zero posts
    other_admin_user = users(:malory)
    get user_path(other_admin_user)
    assert_match '0 posts', response.body
    other_admin_user.posts.create!(content: 'A post')
    get user_path(other_admin_user)
    assert_match "#{other_admin_user.posts.count} post", response.body
  end

  test 'following and followers count' do
    log_in_as(@admin)
    get user_path(@admin)
    assert_template 'users/show'
    assert_select 'div.stats', count: 1
    assert_select '#following', count: 1, text: @admin.following.count.to_s
    assert_select 'a[href=?]', following_user_path
    assert_select '#followers', count: 1, text: @admin.followers.count.to_s
    assert_select 'a[href=?]', followers_user_path
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div.stats', count: 1
    assert_select '#following', count: 1, text: @user.following.count.to_s
    assert_select 'a[href=?]', following_user_path
    assert_select '#followers', count: 1, text: @user.followers.count.to_s
    assert_select 'a[href=?]', followers_user_path
  end
end
