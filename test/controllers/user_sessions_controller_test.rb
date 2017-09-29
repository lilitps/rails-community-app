# frozen_string_literal: true

require 'test_helper'

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get login_path
    assert_response :success
  end
end
