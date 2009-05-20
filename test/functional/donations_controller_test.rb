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

  test "create action on valid donation should render 'create' template" do
    adc = asset_development_cases(:saverCase)
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org

    post :create, :donation => gimme_some_donation_params
                    
    assert_template 'create'
    assert_response :success
  end

  test "create action on invalid donation should render 'new' template" do
    adc = asset_development_cases(:saverCase)
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org

    incomplete_param_list = gimme_some_donation_params
    incomplete_param_list.delete(:saver_id)
    
    post :create, :donation => incomplete_param_list
                    
    assert_template 'new'
    assert_response :success
  end
  
  def gimme_some_donation_params
    adc = asset_development_cases(:saverCase)
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org
    
    # minimum required donation elements
    donation_params = {
      :saver_id => saver.id,
      :notification_email => "a@b.com",
      :donation_line_item_attributes => {
        "0" => {
          :amount => "50.00",
          :account_id => adc.account.id,
          :description => "Donation for Juanita"
          },
        "1" => {
          :amount => "5.00",
          :account_id => stOrg.account.id,
          :description => "Donation for SaveTogether"
          }
        }
      }  
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
