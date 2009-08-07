require 'test_helper'

class SaverStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "The Savers path is redirected to Match Savers" do
    get "/savers"
    assert_redirected_to match_savers_path
    assert_response 301
  end
  
end
