require 'test_helper'

class DonorSurveyStoriesTest < ActionController::IntegrationTest
  fixtures :all

  def setup
    # allows you to inspect email notifications 
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

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

  test "Successful invitation request sends emails" do

    addresses = ["fred@foo.com", "barney@bar.net", "inga@bazinga.org"]
    setup_invitation_test(addresses.join(", "))
    assert_redirected_to "/do-more"

    assert_equal 1, @emails.size
    assert_nil      @emails[0].to
    assert_equal 3, @emails[0].bcc.size

    addresses.each{|address| assert @emails[0].bcc.include?(address)}

    # The email integrity (content) we're already testing in friend_inviter_test
  end
   
  test "Invite request with errors returns errors to the user" do

    bad_addresses = ["bad@address", "notso@good", "thisone@too"]
    addresses     = ["good@address.com"].concat(bad_addresses)
    
    #sanity
    assert_equal 4, addresses.size
    assert_equal 3, bad_addresses.size

    setup_invitation_test(addresses.join(", "))
    assert_response :success

    assert_select "div#errorExplanation" do
      assert_select "ul" do
        assert_select "li", :count => 3
        assert_select "li", /bad@address/
        assert_select "li", /notso@good/
        assert_select "li", /thisone@to/
      end
    end
  end

protected

  def setup_invitation_test(emails)
    title     = "Hey come join the fun!"
    message   = "We're righting a wronged world by helping people to save!"
    
    # try to get a session
    donor = users(:generous_donor)
    post "/sessions", :login => donor.login, :password => 'test'

    post "/do-more/invite", :title => title, :message => message, :emails => emails
  end
  
end
