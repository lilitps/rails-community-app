# frozen_string_literal: true

require 'test_helper'

class ContactCommunityTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'community board of directors and contact' do
    get root_path
    assert_select '#about_board_of_directors', count: 1
    assert_select '#contact', count: 1

    get contact_path
    assert_select '#about_board_of_directors', count: 1
    assert_select '#contact', count: 1
  end

  test 'contact the community with invalid email' do
    get root_path
    assert_template 'static_pages/home'
    # Invalid email
    post contact_path, params: { contact: { name: @user.name, email: '', subject: 'subject', message: 'message' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size

    get contact_path
    assert_template 'contacts/new'
    # Invalid email
    post contact_path, params: { contact: { name: @user.name, email: '', subject: 'subject', message: 'message' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test 'contact the community with invalid email with Ajax' do
    get root_path
    assert_template 'static_pages/home'
    # Invalid email
    post contact_path, params: {
      contact: { name: @user.name, email: '', subject: 'subject', message: 'message' }
    }, xhr: true
    assert_not flash.empty?
    assert_equal 0, ActionMailer::Base.deliveries.size

    get contact_path
    assert_template 'contacts/new'
    # Invalid email
    post contact_path, params: {
      contact: { name: @user.name, email: '', subject: 'subject', message: 'message' }
    }, xhr: true
    assert_not flash.empty?
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test 'contact the community with valid email' do
    get root_path
    assert_template 'static_pages/home'
    # Valid email
    post contact_path, params: {
      contact: { name: @user.name, email: @user.email, subject: 'subject', message: 'message' }
    }
    assert_not flash.empty?
    assert_redirected_to root_path
    assert_equal 1, ActionMailer::Base.deliveries.size

    get contact_path
    assert_template 'contacts/new'
    # Valid email
    post contact_path, params: {
      contact: { name: @user.name, email: @user.email, subject: 'subject', message: 'message' }
    }
    assert_not flash.empty?
    assert_redirected_to root_path
    assert_equal 2, ActionMailer::Base.deliveries.size
  end

  test 'contact the community with valid email with Ajax' do
    get root_path
    assert_template 'static_pages/home'
    # Valid email
    post contact_path, params: {
      contact: { name: @user.name, email: @user.email, subject: 'subject', message: 'message' }
    }, xhr: true
    assert_not flash.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size

    get contact_path
    assert_template 'contacts/new'
    # Valid email
    post contact_path, params: {
      contact: { name: @user.name, email: @user.email, subject: 'subject', message: 'message' }
    }, xhr: true
    assert_not flash.empty?
    assert_equal 2, ActionMailer::Base.deliveries.size
    get root_path
    assert_template 'static_pages/home'
    assert flash.empty?
  end

  test 'contact the community form' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#new_contact'
    assert_select 'input#contact_name'
    assert_select 'input#contact_email'
    assert_select 'input#contact_subject'
    assert_select 'textarea#contact_message'
    assert_select 'div.g-recaptcha'
    assert_select 'input[name=commit]'
    assert_select 'label', 4

    get contact_path
    assert_template 'contacts/new'
    assert_select 'form#new_contact'
    assert_select 'input#contact_name'
    assert_select 'input#contact_email'
    assert_select 'input#contact_subject'
    assert_select 'textarea#contact_message'
    assert_select 'div.g-recaptcha'
    assert_select 'input[name=commit]'
    assert_select 'label', 4
  end

  test 'community directions' do
    get contact_path
    assert_select '#directions', count: 1
    assert_select '#directions > script', count: 1
    assert_select '.directions', count: 1
    assert_select '.about_directions', count: 1
    assert_select '#map', count: 1
    assert_match '/assets/google_maps', response.body
    assert_match 'https://maps.googleapis.com/maps/api/js?', response.body
    assert_match 'callback=initGoogleMap', response.body
  end

  test 'contact the community form with errors' do
    get contact_path
    assert_template 'contacts/new'
    # Invalid name
    post contact_path, params: { contact: { name: '', email: @user.email, subject: 'subject', message: 'message' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_equal 0, ActionMailer::Base.deliveries.size
    # Invalid email
    post contact_path, params: { contact: { name: @user.name, email: '', subject: 'subject', message: 'message' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size
    # Invalid subject
    post contact_path, params: { contact: { name: @user.name, email: @user.email, subject: '', message: 'message' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size
    # Invalid message
    post contact_path, params: { contact: { name: @user.name, email: @user.email, subject: 'subject', message: '' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size
    # Invalid form
    post contact_path, params: { contact: { name: '', email: 'test@mail-.host', subject: '', message: '' } }
    assert_not flash.empty?
    assert flash[:error] == 'You must enter all fields.'
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size
  end
end
