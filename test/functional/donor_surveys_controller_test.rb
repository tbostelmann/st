require File.dirname(__FILE__) + '/../test_helper'

class DonorSurveysControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "Update donor survey content" do
    login_as(:donor)
    donor = users(:donor)

    post :create, {:donor_survey => {
            :donor_id => donor.id,
            :first_name => "Test",
            :last_name => "TestLastName",
            :zip_code => "55406"}}

    assert_template :create
    assert assigns['donor_survey']

    donor = Donor.find(donor.id)
    assert_not_nil donor.donor_survey
    assert flash[:thank_you_for_donor_survey]
  end

  test "Update donor survey content as anonymous" do
    post :create, {:donor_survey => {
            :first_name => "Test",
            :last_name => "TestLastName",
            :zip_code => "55406"}}

    assert_template :create
    assert assigns['donor_survey']
    assert flash[:thank_you_for_donor_survey]
  end

  test "Update donor survey with invalid content as anonymous" do
    post :create, {:donor_survey => {
            :first_name => "",
            :last_name => "TestLastName",
            :zip_code => "5406"}}

    assert_template :new
    donor_survey = assigns['donor_survey']
    assert_not_nil donor_survey
    assert_not_nil donor_survey.errors[:first_name]
    assert_not_nil donor_survey.errors[:zip_code]
    assert_nil flash[:thank_you_for_donor_survey]
  end

  test "Get new survey as anonymous user" do
    get :new

    assert_template :new
    assert_not_nil assigns['donor_survey']
    assert_nil flash[:thank_you_for_donor_survey]
  end

  test "Get new survey as logged in user" do
    login_as(:donor)

    get :new

    assert_template :new
    donor_survey = assigns['donor_survey']
    assert_not_nil donor_survey
    donor = users(:donor)
    assert donor.first_name == donor_survey.first_name
    assert donor.last_name == donor_survey.last_name
    assert donor.id == donor_survey.donor_id
    assert_nil flash[:thank_you_for_donor_survey]
  end
end
