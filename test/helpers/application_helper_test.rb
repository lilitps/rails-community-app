require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'Community App'
    assert_equal full_title('Help'), 'Help | Community App'
  end
end
