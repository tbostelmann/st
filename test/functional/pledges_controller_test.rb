require File.dirname(__FILE__) + '/../test_helper'

class PledgesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  test "get new" do
    saver = users(:saver)
    user = users(:donor)
    login_as(user.login)
    get :new, {:saver_id => saver.id}
    assert_template 'new'
    assert_response :success
  end

  test "review action on valid donation should render 'review' template" do
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org

    post :review, {:saver_id => saver.id, :pledge => gimme_some_donation_params}

    assert_template 'review'
    assert_response :success
  end

#  test "create action on invalid donation should render 'new' template" do
#    adc = asset_development_cases(:saverCase)
#    saver = users(:saver)
#    stOrg = Organization.find_savetogether_org
#
#    incomplete_param_list = gimme_some_donation_params
#    incomplete_param_list.delete(:saver_id)
#
#    post :create, :donation => incomplete_param_list
#
#    assert_template 'new'
#    assert_response :success
#  end
#
  def gimme_some_donation_params
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org

    # minimum required donation elements
    return {
      :notification_email => "a@b.com",
      :notification_email_confirmation => "a@b.com",
      :line_item_attributes => [
        {
          :amount => "50.00",
          :user_id => saver.id
          },
        {
          :amount => "5.00",
          :user_id => stOrg.id
          }
        ]
      }
  end
end
