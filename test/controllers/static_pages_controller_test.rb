# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = I18n.t('community.name')
  end

  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', @base_title.to_s
  end

  test 'should get help' do
    get help_path
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_select 'title', "About | #{@base_title}"
  end

  test 'should get contact' do
    get contact_path
    assert_response :success
    assert_select 'title', "Contact | #{@base_title}"
  end

  test 'should get administration pages' do
    user = users(:lana)
    log_in_as(user)
    # administration menu all users
    get users_path
    assert_select 'title', "All users | #{@base_title}"
  end

  test 'should get membership application pdf' do
    get membership_application_path
    assert_response :success
    assert_equal 'application/pdf', response.content_type
    assert_equal 'attachment; filename="sifez-aufnahmeantrag.pdf"', response.headers['Content-Disposition']
  end
end
