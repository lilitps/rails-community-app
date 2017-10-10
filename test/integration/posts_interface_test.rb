# frozen_string_literal: true

require 'test_helper'

# Tests posts submission and deleting interface
class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
    @post = posts(:orange)
  end

  test 'post submission interface' do
    log_in_as(@non_admin)
    get root_path
    assert_select 'div.pagination-sm'
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '' } }
    end
    log_out
    # Invalid submission as admin
    log_in_as(@admin)
    get root_path
    assert_select 'input[type=file]'
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '' } }
    end
    assert_select 'div#error_explanation'
    # Valid submission (only admin)
    content = 'This post really ties the room together'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, picture: picture } }
    end
    assert_not flash.empty?
    assert @admin.posts.first.picture?
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body
  end

  test 'post submission interface with Ajax' do
    log_in_as(@admin)
    get root_path
    # Valid submission (only admin)
    content = 'This post really ties the room together'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, picture: picture } }, xhr: true
    end
    assert_not flash.empty?
    assert @admin.posts.first.picture?
    assert_match content, response.body
  end

  test 'post delete interface' do
    # delete as admin
    log_in_as(@admin)
    get root_path
    # Delete post
    assert_select 'a', text: 'delete'
    first_post = @admin.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    assert_not flash.empty?
    # Visit different user as admin
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 2
    log_out
    # Visit different user as non admin (no delete links)
    log_in_as(@non_admin)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'post delete interface with Ajax' do
    # delete as admin
    log_in_as(@admin)
    get root_path
    # Delete post
    assert_select 'a', text: 'delete'
    first_post = @admin.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post), xhr: true
    end
    assert_not flash.empty?
  end

  test 'post update interface' do
    log_in_as(@admin)
    get root_path
    content = ''
    assert_no_difference 'Post.count' do
      patch post_path(@post), params: { post: { content: content } }
    end
    assert_select 'div#error_explanation'
    content = 'This post really ties the room together'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_no_difference 'Post.count' do
      patch post_path(@post), params: { post: { content: content, picture: picture } }
    end
    assert_not flash.empty?
    @post.reload
    assert_equal @post.content, content
    assert_not_nil @post.picture
    assert_equal @post.picture.file.filename, picture.original_filename
  end

  test 'post update interface with Ajax' do
    log_in_as(@admin)
    get root_path
    content = 'This post really ties the room together'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_no_difference 'Post.count' do
      patch post_path(@post), params: { post: { content: content, picture: picture } }, xhr: true
    end
    assert_not flash.empty?
    @post.reload
    assert_equal @post.content, content
    assert_not_nil @post.picture
    assert_equal @post.picture.file.filename, picture.original_filename
  end
end
