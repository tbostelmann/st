require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  test "get new" do
    saver = users(:saver)
    user = users(:donor)
    login_as(user.login)
    get :new, {:saver_id => saver.id}
    assert_response :success
  end

  test "create donation" do
    adc = asset_development_cases(:saverCase)
    user = users(:donor)
    login_as(user.login)
    stOrg = Organization.find_savetogether_org

    post :create, :donation => {:user_id => user.id},
                  :donation_line_item_attributes => [
                          "0", {
                            :amount => "50.00",
                            :account_id => adc.account.id,
                            :description => "Donation for Juanita"},
                          "1", {
                            :amount => "5.00",
                            :account_id => stOrg.account.id,
                            :description => "Donation for SaveTogether"}]
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
