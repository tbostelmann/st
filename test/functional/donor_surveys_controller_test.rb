require File.dirname(__FILE__) + '/../test_helper'

class DonorSurveysControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "Update donor survey content" do
    login_as(:donor)
    donor = users(:donor)
    ds = donor.donor_survey
    assert !ds.nil?
    assert !ds.add_me_to_cfed_petition

    post :update, {:donor_survey => {
            :add_me_to_cfed_petition => true}}

    assert_template :edit

    donor = Donor.find(donor.id)
    assert !donor.donor_survey.nil?
    assert donor.donor_survey.add_me_to_cfed_petition
  end
end
