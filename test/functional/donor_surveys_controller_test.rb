require File.dirname(__FILE__) + '/../test_helper'

class DonorSurveysControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    # allows you to inspect email notifications 
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end
  
  test "Update donor survey content" do
    login_as(:donor)
    donor = users(:donor)

    post :create, {:donor_survey => {
            :donor_id => donor.id,
            :first_name => "Test",
            :last_name => "TestLastName",
            :zip_code => "55406"}}

    assert_response :redirect
    assert_redirected_to :action => :show
    
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

    assert_response :redirect
    assert_redirected_to :action => :show

    assert assigns['donor_survey']
    assert flash[:thank_you_for_donor_survey]
  end

  test "Update donor survey with invalid content as anonymous" do
    post :create, {:donor_survey => {
            :first_name => "",
            :last_name => "TestLastName",
            :zip_code => "5406"}}

    # Its an error state, but the page renders, so that's success
    assert_response :success

    # Assert error state down here
    donor_survey = assigns['donor_survey']
    assert_not_nil donor_survey
    assert_not_nil donor_survey.errors[:first_name]
    assert_not_nil donor_survey.errors[:zip_code]
    assert_nil flash[:thank_you_for_donor_survey]
  end

  test "Get new survey as anonymous user" do
    get :show

    assert_response :success
    # assert_template :foo - this is successful - why?

    assert_not_nil assigns['donor_survey']
    assert_nil flash[:thank_you_for_donor_survey]
  end

  test "Get new survey as logged in user" do
    login_as(:donor)

    get :show

    assert_response :success
    # assert_template :bar - this is successfull - why?

    donor_survey = assigns['donor_survey']
    assert_not_nil donor_survey
    donor = users(:donor)
    assert donor.first_name == donor_survey.first_name
    assert donor.last_name == donor_survey.last_name
    assert donor.id == donor_survey.donor_id
    assert_nil flash[:thank_you_for_donor_survey]
  end
  
  test "An invitation can only be sent by a logged in user" do
    post :invite
    assert_redirected_to login_path
  end
  
  / Until we can figure out test_helper#login, this test will
    have to move to integration tests where the multiple controller
    per test rule doesn't exist
  test "Successful invitation request sends emails" do
    
    title = "Hey come join the fun!"
    message = "We're righting a wronged world by helping people to save!"
    recips  = "fred@foo.com barney@bar.net inga@bazinga.org"
    
    login # see test_helper.rb
    
    post :invite, :title => title, :message => message, :friends => recips
    assert_response :success
    
    assert_equal 1, @emails.size
    assert_equal "[SaveTogether] Your SaveTogether account has been activated!", @emails[0].subject
  end
  /
end
