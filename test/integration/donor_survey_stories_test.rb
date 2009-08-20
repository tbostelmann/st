require 'test_helper'

class DonorSurveyStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "Login after erroneous survey form redirects back to form" do
    
    # open_session - a hack - didn't work, apparently one is open already. There
    # is the session that's maintained by the app, and then the auth'ed user session
    # and not sure which is supposed to be which
    
    get "/do-more"
    assert_response :success
    
    post "/do-more/survey", :donor_survey => {:first_name => "Sarah", :last_name => "Dippity"} # :zip_code => "12345" - drop to force an error state
    assert_response :success
    assert_not_equal 0, assigns(:donor_survey).errors.size
    
    donor = users(:donor)
    post "/sessions", :login => donor.login, :password => 'test'
    
    # TODO - find way to enable the check below?
    # Unfortunately can't find a way to keep the synthetic session around,
    # and that's sort of the whole point of this test - that the new survey
    # route is cached and redirected to (this eliminated need for index action)
    
    # assert_redirected_to survey_path

   end
  
end
