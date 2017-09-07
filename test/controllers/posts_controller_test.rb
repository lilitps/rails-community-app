require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:orange)
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: 'Lorem ipsum' } }
    end
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get edit_post_path(@post)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch post_path(@post), params: { post: { content: 'Edit Lorem ipsum' } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_post_path(@post)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch post_path(@post), params: { post: { content: 'Edit Lorem ipsum' } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy for wrong post' do
    log_in_as(@user)
    post = posts(:ants)
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    assert_redirected_to root_url
  end
end
