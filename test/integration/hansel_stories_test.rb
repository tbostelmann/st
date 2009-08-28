require 'test_helper'

class NavigationStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "Can get a friendly record of user flow" do
    
    # open_session - a hack - didn't work, apparently one is open already. There
    # is the session that's maintained by the app, and then the auth'ed user session
    # and not sure which is supposed to be which
    
    get "/"
    assert_response :success
    
    get "/match-savers/"
    assert_response :success
    
    get "/community/"
    assert_response :success

    # Can't figure out how to retrieve a donor id via fixtures...
    # donor = users(:generous_donor)
    donor = mock_donor
    donor.save!
    get "/donors/#{donor.id}"
    assert_response :success
    
    friendly_names = session[:crumb_trail].to_s
    
    assert_match /[ ]*\/[,]/, friendly_names
    assert_match Regexp.new(Regexp.escape("/match-savers/")), friendly_names
    assert_match Regexp.new(Regexp.escape("/community/")), friendly_names

    assert_no_match Regexp.new(Regexp.escape("/donors/#{donor.id}")), friendly_names
    assert_match Regexp.new(Regexp.escape("/donors/[0-9]+")), friendly_names
  
  end
  
protected

  # This sucks, but this is here because currently can't figure out how to get to
  # the user fixtures in integration tests and pull one of the simple donors. So
  # We're defining on the fly:
  
  def mock_donor(options = {})
    Donor.new({
      :first_name => "Newt",
      :last_name => "Donor",
      :login => "a@b.com",
      :login_confirmation => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago,
      :role => Role[:member]
      }.merge(options))
  end

end
