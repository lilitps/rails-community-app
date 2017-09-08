# frozen_string_literal: true

require 'test_helper'

# Tests Facebook feed on home page if Koala is configured
class SiteFbFeedTest < ActionDispatch::IntegrationTest
  include PostsHelper
  include ActionView::Helpers::TextHelper

  test 'should display first 3 facebook page posts on home page feed' do
    if Koala.config.app_id.present? && Koala.config.app_secret.present?
      get root_path
      assert_template 'static_pages/home'
      assert_select 'div#fb-feed', count: 1
      assert_select '#fb-feed>div>div>.thumbnail', count: 3
      feed = fb_feed
      assert_not feed.empty?
      feed.each do |post|
        assert_select 'div#post-' + post['id'], count: 1
        if post['message'].present? && post['message'].length > 150
          assert_match auto_format_html(truncate(post['message'], length: 150)), response.body
          assert_select '.read-more-' + post['id'], count: 1
          assert_select '.read-more-description-' + post['id'], count: 1
        else
          assert_match auto_format_html(post['message']), response.body
        end
        assert_select 'a[href=?]', post['permalink_url']
      end
    end
  end
end
