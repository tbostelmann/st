require File.dirname(__FILE__) + '/../test_helper'

class DonorSurveysControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "Update donor survey content" do
    login_as(:donor4)
    donor = users(:donor4)
    assert donor.donor_survey.nil?

    post :update, {:donor_survey => {
            :donor_id => donor.id.to_s,
            :add_me_to_cfed_petition => "1"}}

    assert_template :edit

    donor = Donor.find(donor.id)
    assert !donor.donor_survey.nil?
    assert donor.donor_survey.add_me_to_cfed_petition
  end
end
