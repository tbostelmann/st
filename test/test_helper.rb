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

  def create_ipn(pledge)
    create_notification(pledge, {
            :payment_fee => '1.90',
            :mc_fee => '1.90',
            :payment_type => 'instant',
            })
  end

  def create_notification(pledge, add_params = {})
    donor = pledge.donor
    notification = {
      :mc_gross => "#{pledge.total_amount_for_donations}",
      :invoice => "#{pledge.id}",
      :protection_eligibility => 'Ineligible',
      :payer_id => 'YMQMYSZ5LYANL',
      :tax => '0.00',
      :payment_date => '11-20-07 May 27, 2009 PDT',
      :payment_status => 'Completed',
      :charset => 'windows-1252',
      :mc_shipping => '0.00',
      :mc_handling => '0.00',
      :first_name => "#{donor.first_name}",
      :notify_version => '2.8',
      :custom => '',
      :payer_status => 'verified',
      :business => 'tom@savetogether.org',
      :payer_email => "#{donor.email}",
      :verify_sign => 'AREFmIS0FirenwdngMCN-lqksBYNA668VwpM1h4AHQvdR7JzWkCS4nJ0',
      :txn_id => '86J700648N228641Y',
      :last_name => "#{donor.last_name}",
      :receiver_email => 'tom@savetogether.org',
      :receiver_id => 'ZK62HKKPR4NTE',
      :txn_type => 'cart',
      :mc_currency => 'USD',
      :residence_country => 'US',
      :test_ipn => '1',
      :transaction_subject => 'Shopping Cart',
      :payment_gross => "#{pledge.total_amount_for_donations}",
      :merchant_return_link => 'Return to SaveTogether',
      :auth => 'ZYTlDZ4v57sLTuL7WyZ6m2yqSuVYbjpLtndecieoKRVQMBLnqoLGzVeW0fLuVGIo2x3RJtPa-bB-i7--'
    }
    if pledge.donations
      i = 1
      notification['num_cart_items'] = "#{pledge.donations.size}"
      pledge.donations.each do |donation|
        notification["item_number#{i}"] = "#{donation.to_user.id}"
        notification["tax#{i}"] = '0.00'
        notification["mc_handling#{i}"] = '0.00'
        notification["mc_shipping#{i}"] = '0.00'
        notification["item_name#{i}"] = "#{donation.to_user.display_name}"
        notification["quantity#{i}"] = '1'
        notification["mc_gross_#{i}"] = "#{donation.amount.to_s}"
        i = i + 1
      end
    end

    return notification.merge(add_params)
  end

  def assert_number_gifts(num = 1)
    pledge = get_pledge
    assert !pledge.nil?
    assert !pledge.gifts.nil?
    assert pledge.gifts.size == num
  end
end
