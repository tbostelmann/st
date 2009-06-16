require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "show an organization" do
    org = users(:earn)
    get :show, {:id => org.id}
    assert_response :success
    assert_template :show

    storg = users(:savetogether)
    get :show, {:id => storg.id}
    assert_response :success
    assert_template :show
  end
end
