require File.dirname(__FILE__) + '/../test_helper'

class LineItemsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "test search criteria" do
    login_as(:admin)

    get :list, {:month => "6"}
    assert_response :success

    get :list, {:month => "6", :year => "2008"}
    assert_response :success

    get :list, {:year => "2009"}
    assert_response :success    
  end
end