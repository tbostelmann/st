require 'test_helper'

class DonorStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "The Donors path is redirected to Community" do
    get "/donors"
    assert_redirected_to community_path(:trailing_slash => false)
  end
  
end
