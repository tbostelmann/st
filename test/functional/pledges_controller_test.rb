require File.dirname(__FILE__) + '/../test_helper'

class PledgesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  test "get new" do
    saver = users(:saver)
    get :new, {:saver_id => saver.id}
    assert_template 'new'
    assert_response :success
  end

  test "create valid donation and register valid user should render 'create' template" do
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org

    post :create, {:saver_id => saver.id,
                   :pledge => pledge_params(saver),
                   :donor => new_donor_params('testlogin'), }

    assert_template 'create'
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
  private
  def new_donor_params(login)
    return {
        :login => login,
        :email => "#{login}@example.com",
        :password => "password",
        :password_confirmation => "password"}
  end

  def pledge_params(saver)
    stOrg = Organization.find_savetogether_org

    # minimum required donation elements
    return {
        :line_item_attributes => {
          "0" => {
            :amount => "50.00",      
            :to_user_id => saver.id
            },
          "1" => {
            :amount => "5.00",
            :to_user_id => stOrg.id
            }
          }
        }
  end
end
