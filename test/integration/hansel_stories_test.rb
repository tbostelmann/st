require 'test_helper'

class NavigationStoriesTest < ActionController::IntegrationTest
  fixtures :all

  #test "Can get a friendly record of user flow" do
  #
  #  # open_session - a hack - didn't work, apparently one is open already. There
  #  # is the session that's maintained by the app, and then the auth'ed user session
  #  # and not sure which is supposed to be which
  #
  #  get "/"
  #  assert_response :success
  #
  #  get "/match-savers/"
  #  assert_response :success
  #
  #  get "/community/"
  #  assert_response :success
  #
  #  # Can't figure out how to retrieve a donor id via fixtures...
  #  # donor = users(:generous_donor)
  #  donor = mock_donor
  #  donor.save!
  #  get "/donors/#{donor.id}"
  #  assert_response :success
  #
  #  assert_select "div.bread-crumb-links" do
  #    assert_select "ul" do
  #      assert_select "li", :count => 4
  #      assert_select "li > a[href=/]", /Home/
  #      assert_select "li > a[href=/match-savers/]", /Match Savers/
  #      assert_select "li > a[href=/community/]", /Community/
  #      assert_select "li > a[href=/donors/#{donor.id}]", :count => 0 # No link for the last path visited
  #      assert_select "li", /Donor Profile/ # instead just a list element
  #    end
  #  end
  #
  #end
  
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
