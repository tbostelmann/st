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
    stOrg = Organization.find_savetogether_org
    user = users(:quentin)
    login_as(user.login)
    beneficiary = beneficiaries(:minBeneficiary)

    post :create, :donation => {:user_id => user.id},
                  :beneficiary_id => beneficiary.id,
                  :bpli => {:amount => 25, :from_account_id => user.account.id,
                            :to_account_id => beneficiary.account.id,
                            :description => "Donation to #{beneficiary.profile.name}"},
                  :stpli => {:amount => 2.50, :from_account_id => user.account.id,
                            :to_account_id => stOrg.account.id,
                            :description => "Donation to #{stOrg.profile.name}"},
                  :user_id => user.id
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
