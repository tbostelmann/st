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

    donor = Donor.find(donor.id)
    assert !donor.donor_survey.nil?
  end
end
