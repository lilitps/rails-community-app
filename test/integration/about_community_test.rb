# frozen_string_literal: true

require "test_helper"

class AboutCommunityTest < ActionDispatch::IntegrationTest
  test "community membership" do
    get about_path
    assert_select "#description", count: 1
    assert_select "#history", count: 1
    assert_select "#membership", count: 1
    assert_select "#fee", count: 1
    assert_select "table#admission_fee", count: 1
    assert_select "tr", count: 4
    assert_select "th", count: 4
    assert_select "td", count: 12
  end
end
