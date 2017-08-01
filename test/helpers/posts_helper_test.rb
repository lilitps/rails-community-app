require 'test_helper'

class PostsHelperTest < ActionView::TestCase

  test "should get facebook app client" do
    if Koala.config.app_id.present? && Koala.config.app_secret.present?
      assert_not_nil facebook_app_client
    end
  end

  test "should get 3 posts from facebook page" do
    if Koala.config.app_id.present? && Koala.config.app_secret.present?
      feed = fb_feed
      assert_not_nil feed
      assert feed.any?
      assert feed.to_a.count == 3
      post_keys = %w(id type icon name message permalink_url link full_picture description created_time).to_a
      feed.each do |post|
        assert post_keys.to_a.any? {|k| post.key?(k)}
        assert post.key?('story') if post['type'] == 'event' || post['type'] == 'photo'
      end
    end
  end

  test "should simple format a text with html tags" do
    text = 'Nur noch eine Woche bis zurLange Nacht der Astronomie 2017!\nWir freuen uns auf eueren Besuch am #Gleisdreieck und bringen euch gerne dem Himmel etwas näher!'
    simple_formated_text = '<p>Nur noch eine Woche bis zurLange Nacht der Astronomie 2017!\\nWir freuen uns auf eueren Besuch am #Gleisdreieck und bringen euch gerne dem Himmel etwas näher!</p>'
    assert_equal auto_format_html(text), simple_formated_text
  end
end