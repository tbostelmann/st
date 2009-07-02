require File.dirname(__FILE__) + '/../test_helper'

class DonorSurveysControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "Update donor survey content" do
    login_as(:donor)
    donor = users(:donor)
    assert donor.donor_survey.nil?

    post :update, {:donor_survey => {
            :donor_id => donor.id,
            :first_name => "Test",
            :last_name => "TestLastName",
            :zip_code => "55406"}}

    assert_template :edit
    assert assigns['pledge'].nil?    

    donor = Donor.find(donor.id)
    assert_not_nil donor.donor_survey
  end

  test "Update donor survey content as anonymous" do
    post :update, {:donor_survey => {
            :first_name => "Test",
            :last_name => "TestLastName",
            :zip_code => "55406"}}

    assert_template :edit
    assert_nil assigns['pledge']
    assert_nil assigns['donor_survey']
  end

  test "Get new survey as anonymous user" do
    get :new

    assert_template :edit
    assert_nil assigns['pledge']
    assert_not_nil assigns['donor_survey']
  end

  test "Get new survey as logged in user" do
    login_as(:donor)

    get :new

    assert_template :edit
    assert_nil assigns['pledge']
    assert_not_nil assigns['donor_survey']
  end

  test "Get new survey as logged in user who has previously filled out survey" do
    donor = users(:donor)
    login_as(:donor)
    DonorSurvey.create(:donor => donor, :first_name => "Test", :last_name => "Tester", :zip_code => "55406")

    get :new

    assert_template :edit
    assert_nil assigns['pledge']
    assert_nil assigns['donor_survey']
  end
end
