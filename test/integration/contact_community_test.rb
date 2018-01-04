# frozen_string_literal: true

require 'test_helper'

class ContactCommunityTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'contact the community with invalid email' do
    get contact_path
    assert_template 'contacts/new'
    # Invalid email
    post contact_path, params: { contact: { name: @user.name, email: '', subject: 'subject', message: 'message' } }
    assert_not flash.empty?
    assert_template 'contacts/new'
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test 'contact the community with valid email' do
    # Valid email
    post contact_path, params: {
      contact: { name: @user.name, email: @user.email, subject: 'subject', message: 'message' }
    }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'contact the community form' do
    get contact_path
    assert_template 'contacts/new'
    assert_select 'form#new_contact'
    assert_select 'input#contact_name'
    assert_select 'input#contact_email'
    assert_select 'input#contact_subject'
    assert_select 'textarea#contact_message'
    assert_select 'div.simple_captcha'
    assert_select 'div.simple_captcha_image'
    assert_select 'img[alt=captcha]'
    assert_select 'div.simple_captcha_field'
    assert_select 'input[name=captcha]'
    assert_select 'input[name=captcha_key]'
    assert_select 'input[name=commit]'
    assert_select 'label', 4
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