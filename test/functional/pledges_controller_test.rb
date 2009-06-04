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

    donor = Donor.find_by_login('testlogin')
    assert donor.nil?

    post :create, {
        :saver_id => saver.id,
        :pledge => { :donation_attributes => pledge_params(saver) },
        :donor => {
          :login => 'testlogin@example.com',
          :login_confirmation => "testlogin@example.com",
          :password => "password",
          :password_confirmation => "password"} }

    assert_template 'create'
    assert_response :success

    donor = Donor.find_by_login('testlogin@example.com')
    assert !donor.nil?

    # Use donor to find pledge and assert they're the same
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]

    test_pledge_no_fees(d_pledge)

    # Reload pledge and assert it's values
    pledge = Pledge.find(d_pledge.id)
    assert !pledge.nil?
    d_pledge.id == pledge.id

    test_pledge_no_fees(pledge)
  end

  test "create valid donation and login valid user should render 'create' template" do
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org
    donor = users(:donor4)

    post :create, {
        :commit => :log_in.l,
        :saver_id => saver.id,
        :pledge => { :donation_attributes => pledge_params(saver) },
        :login => donor.login,
        :password => "test"}

    assert_template 'create'
    assert_response :success

    donor = Donor.find(donor.id)
    assert !donor.nil?

    # Use donor to find pledge and assert they're the same
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]

    test_pledge_no_fees(d_pledge)

    # Reload pledge and assert it's values
    pledge = Pledge.find(d_pledge.id)
    assert !pledge.nil?
    d_pledge.id == pledge.id

    test_pledge_no_fees(pledge)
  end

  test "create valid donation with logged in user should render 'create' template" do
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org
    donor = users(:donor4)
    login_as(:donor4)

    post :create, {
        :saver_id => saver.id,
        :pledge => { :donation_attributes => pledge_params(saver) }}

    assert_template 'create'
    assert_response :success

    donor = Donor.find(donor.id)
    assert !donor.nil?

    # Use donor to find pledge and assert they're the same
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]

    test_pledge_no_fees(d_pledge)

    # Reload pledge and assert it's values
    pledge = Pledge.find(d_pledge.id)
    assert !pledge.nil?
    d_pledge.id == pledge.id

    test_pledge_no_fees(pledge)
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
end
