ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # This clever idea courtesy of
  # http://alexbrie.net/1526/functional-tests-with-login-in-rails/
  #
  # Gets around the ActionController::TestCase restriction on a
  # single controller per test class, but specifically, to allow
  # one to get a login against the sessions controller so that
  # a valid, authorized session exists in the request. Then, restricted
  # actions can be tested against. (See DonorSurveysControllerTest#invite)
  
  # It's a good thought, currently can't get it to work. Not sure if the forgery
  # protection stuff is getting the way (the login form also passes an authenticity
  # based on session, but can't find out enough docs to know if that's the problem here)
  def login(login = 'gennydonor@example.com', password =' test')
    old_controller = @controller
    
    @controller = SessionsController.new
    post :login, :login => login, :password => password
    # assert_redirected_to :controller => tsap, :action=>'overview'
    assert_not_nil(session[:user])
    
    @controller = old_controller
  end

  def pledge_params(saver)
    stOrg = Organization.find_savetogether_org

    # minimum required donation elements
    return {
          "0" => {
            :amount => "50.00",
            :to_user_id => saver.id
            },
          "1" => {
            :amount => "5.00",
            :to_user_id => stOrg.id
            }
          }    
  end

  def invalid_pledge_params(saver)
    pparams = pledge_params(saver)
    pparams["0"][:amount] = "not a number"
    return pparams
  end

  def test_pledge_no_fees(pledge)
    test_basic_pledge(pledge)

    fees = pledge.fees
    assert fees.size == 0
  end

  def test_pledge_with_fees(pledge)
    test_basic_pledge(pledge)

    fees = pledge.fees
    assert fees.size == 1
  end

  def test_basic_pledge(pledge)
    line_items = pledge.line_items
    assert !line_items.empty?
    assert line_items.size == 2

    donations = pledge.donations
    assert !donations.empty?
    assert donations.size == 2

    donor = pledge.donor
    assert !donor.nil?
    assert donor.all_donations_given.size >= 2
    assert donor.pledges.size > 0
  end
end
