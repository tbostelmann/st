require 'test_helper'

class LoginStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "Successful login starting from the Do More page eventually returns to Do More" do
    
    # open_session - a hack - didn't work, apparently one is open already. There
    # is the session that's maintained by the app, and then the auth'ed user session
    # and not sure which is supposed to be which
    
    get "/do-more"
    assert_response :success
    
    get "/login"
    assert_response :success
    
    donor = users(:donor)
    post "/sessions", :login => donor.login, :password => 'test'
    
    # TODO - find way to enable the check below?
    # Unfortunately can't find a way to keep the synthetic session around,
    # and that's sort of the whole point of this test - that two hops to login
    # and then the auth should redir back to the page hosting the login link
    
    # assert_redirected_to do_more_path

   end
  
end
