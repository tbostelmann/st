require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  test "get new" do
    adc = asset_development_cases(:saverCase)
    user = users(:donor)
    login_as(user.login)
    get :new, {:asset_development_case_id => adc.id}
    assert_response :success
  end

  test "create donation" do
    adc = asset_development_cases(:saverCase)
    user = users(:donor)
    login_as(user.login)
    stOrg = Organization.find_savetogether_org

    post :create, :donation => {:user_id => user.id},
                  :asset_development_case_id => adc.id,
                  :sdli => {:cents => 2500, :account => adc.account,
                            :description => "Donation to #{adc.user.display_name}"},
                  :stdli => {:cents => 250, :account => stOrg.account,
                            :description => "Donation to #{stOrg.name}"}
    assert_response :success
  end

#    assert_redirected_to donation_path(assigns(:donation))
#  end
#
#  def test_should_show_donation
#    get :show, :id => donations(:one).id
#    assert_response :success
#  end
#
#  def test_should_get_edit
#    get :edit, :id => donations(:one).id
#    assert_response :success
#  end
#
#  def test_should_update_donation
#    put :update, :id => donations(:one).id, :donation => { }
#    assert_redirected_to donation_path(assigns(:donation))
#  end
#
#  def test_should_destroy_donation
#    assert_difference('Donation.count', -1) do
#      delete :destroy, :id => donations(:one).id
#    end
#
#    assert_redirected_to donations_path
#  end
end
