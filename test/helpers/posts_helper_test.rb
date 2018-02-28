# frozen_string_literal: true

require 'test_helper'

class PostsHelperTest < ActionView::TestCase
  test 'should get facebook app client' do
    assert_not_nil facebook_app_client if Koala.config.app_id.present? && Koala.config.app_secret.present?
  end

  test 'should get 3 posts from facebook page' do
    if Koala.config.app_id.present? && Koala.config.app_secret.present?
      feed = fb_feed
      assert_not_nil feed
      assert feed.any?
      assert feed.to_a.size == 3
      feed.each do |post|
        assert PostsHelper::FIELDS.to_a.any? do |k|
          post.key?(k)
        end
      end
    end
  end

  test 'should simple format a text with html tags' do
    # rubocop:disable LineLength
    text = 'Nur noch eine Woche bis zurLange Nacht der Astronomie 2017!\nWir freuen uns auf eueren Besuch am #Gleisdreieck und bringen euch gerne dem Himmel etwas näher!'
    simple_formated_text = '<p>Nur noch eine Woche bis zurLange Nacht der Astronomie 2017!\\nWir freuen uns auf eueren Besuch am #Gleisdreieck und bringen euch gerne dem Himmel etwas näher!</p>'
    assert_equal auto_format_html(text), simple_formated_text
    # rubocop:enable LineLength
  end
end
