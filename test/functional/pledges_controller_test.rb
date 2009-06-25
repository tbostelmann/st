require File.dirname(__FILE__) + '/../test_helper'

class PledgesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "go to savetogether ask page not logged in" do
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id

    get :savetogether_ask

    assert_redirected_to signup_or_login_path
  end

  test "go to savetogether ask page logged in" do
    login_as(:donor4)
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id

    get :savetogether_ask
    assert_response :success
    assert_template :savetogether_ask
  end

  test "add savetogether donation" do
    login_as(:donor4)
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id

    post :add_savetogether_to_pledge, {:donation => {
            :to_user_id => Organization.find_savetogether_org.id,
            :cents => "125"}}

    assert_response :success
    assert_template 'show'

    assert session[:pledge_id].nil?
    
    pledge = Pledge.find(pledge.id)
    d = pledge.find_donation_with_to_user_id(Organization.find_savetogether_org.id)
    assert !d.nil?
    assert d.cents.to_s == "125"
  end

  test "add donation to pledge" do
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id
    donation = pledge.donations[0]
    c = donation.cents
    c = c + 10000

    post :add_to_pledge, {:donation => {
            :to_user_id => donation.to_user.id,
            :cents => c.to_s}}

    assert_response :success
    assert_template 'edit'

    pledge = Pledge.find(session[:pledge_id])
    d = pledge.find_donation_with_to_user_id(donation.to_user_id)
    assert !d.nil?
    assert d.cents != donation.cents
    assert d.cents == c
  end

  test "remove donation from pledge" do
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id
    donation = pledge.donations[0]

    post :remove_from_pledge, {:donation => {
            :to_user_id => donation.to_user.id}}

    assert_response :success
    assert_template 'edit'

    pledge = Pledge.find(session[:pledge_id])
    d = pledge.find_donation_with_to_user_id(donation.to_user_id)
    assert d.nil?
  end
  
  def TODO_add_this_test # "modify pledge by remove request" do
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id
    donation = pledge.donations[0]
    
    # test should fail as written until a 'commit' param is added
    # to params containing :remove.l
    # Current test is failing because an erb is expected for modify_pledge.
    # TODO figure out how to instruct that this action isn't bound to a view
    post :modify_pledge, {:donation => {:to_user_id => donation.to_user.id}}
    assert_response :success
    assert_template 'edit'
    
    pledge = Pledge.find(session[:pledge_id])
    d = pledge.find_donation_with_to_user_id(donation.to_user_id)
    assert d.nil?
  end

  test "get cancel" do
    get :cancel
    assert_response :success
    assert_template :cancel
  end
  
  #test "get new" do
  #  saver = users(:saver)
  #  get :new, {:saver_id => saver.id}
  #  assert_template 'new'
  #  assert_response :success
  #end
  #
  #test "create invalid pledge with no donations as anonymous user" do
  #  saver = users(:saver)
  #  stOrg = Organization.find_savetogether_org
  #
  #  post :create, {
  #      :saver_id => saver.id,
  #      :pledge => { :donation_attributes => {} }}
  #
  #  assert_response :success
  #  assert_template 'new'
  #end
  #
  #test "create valid pledge using post with logged in user" do
  #  saver = users(:saver)
  #  stOrg = Organization.find_savetogether_org
  #  donor = users(:donor4)
  #  login_as(:donor4)
  #
  #  post :create, {
  #      :saver_id => saver.id,
  #      :pledge => { :donation_attributes => pledge_params(saver) }}
  #
  #  assert_response :success
  #  assert_template 'create'
  #
  #  donor = Donor.find(donor.id)
  #  assert !donor.nil?
  #
  #  # Use donor to find pledge and assert they're the same
  #  assert !donor.pledges.empty?
  #  d_pledge = donor.pledges[0]
  #
  #  test_pledge_no_fees(d_pledge)
  #
  #  # Reload pledge and assert it's values
  #  pledge = Pledge.find(d_pledge.id)
  #  assert !pledge.nil?
  #  d_pledge.id == pledge.id
  #
  #  test_pledge_no_fees(pledge)
  #end

  #test "create valid pledge as anonymous user" do
  #  saver = users(:saver)
  #  stOrg = Organization.find_savetogether_org
  #
  #  post :create, {
  #      :saver_id => saver.id,
  #      :pledge => { :donation_attributes => pledge_params(saver) }}
  #
  #  assert_redirected_to :signup_or_login
  #
  #  pledge = session[:pledge]
  #  assert !pledge.nil?
  #end

  #test "create invalid pledge as anonymous user" do
  #  saver = users(:saver)
  #  stOrg = Organization.find_savetogether_org
  #
  #  post :create, {
  #      :saver_id => saver.id,
  #      :pledge => { :donation_attributes => invalid_pledge_params(saver) }}
  #
  #  assert_response :success
  #  assert_template 'new'
  #end

  test "complete a pledge using an IPN" do
    pledge = invoices(:pledge2)
    saver = users(:saver2)
    storg = Organization.find_savetogether_org
    donor = users(:donor2)

    completed_donations = donor.donations_given.size
    li_count = pledge.line_items.size

    post :notify, {
      :mc_gross => "55.00",
      :invoice => "#{pledge.id}",
      :protection_eligibility => 'Ineligible',
      :item_number1 => "#{saver.id}",
      :item_number2 => "#{storg.id}",
      :payer_id => 'YMQMYSZ5LYANL',
      :tax => '0.00',
      :payment_date => '11-20-07 May 27, 2009 PDT',
      :payment_status => 'Completed',
      :charset => 'windows-1252',
      :mc_shipping => '0.00',
      :mc_handling => '0.00',
      :first_name => 'Test',
      :mc_fee => '1.90',
      :notify_version => '2.8',
      :custom => '',
      :payer_status => 'verified',
      :business => 'tom@savetogether.org',
      :num_cart_items => '2',
      :mc_handling1 => '0.00',
      :mc_handling2 => '0.00',
      :payer_email => 'tom_1233251324_per@savetogether.org',
      :verify_sign => 'AREFmIS0FirenwdngMCN-lqksBYNA668VwpM1h4AHQvdR7JzWkCS4nJ0',
      :mc_shipping1 => '0.00',
      :mc_shipping2 => '0.00',
      :tax1 => '0.00',
      :tax2 => '0.00',
      :txn_id => '86J700648N228641Y',
      :payment_type => 'instant',
      :last_name => 'User',
      :receiver_email => 'tom@savetogether.org',
      :item_name1 => 'samantha',
      :payment_fee => '1.90',
      :item_name2 => 'savetogether',
      :quantity1 => '1',
      :receiver_id => 'ZK62HKKPR4NTE',
      :quantity2 => '1',
      :txn_type => 'cart',
      :mc_currency => 'USD',
      :mc_gross_1 => '50.00',
      :mc_gross_2 => '5.00',
      :residence_country => 'US',
      :test_ipn => '1',
      :transaction_subject => 'Shopping Cart',
      :payment_gross => '55.00',
      :merchant_return_link => 'Return to SaveTogether',
      :auth => 'ZYTlDZ4v57sLTuL7WyZ6m2yqSuVYbjpLtndecieoKRVQMBLnqoLGzVeW0fLuVGIo2x3RJtPa-bB-i7--'
    }

    assert_response :success

    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > li_count

    donor = Donor.find(donor.id)
    assert donor.donations_given.size > completed_donations
  end

  test "complete a pledge when returning to st site" do
    pledge = invoices(:pledge2)
    saver = users(:saver2)
    storg = Organization.find_savetogether_org
    donor = users(:donor2)
    login_as(:donor2)

    completed_donations = donor.donations_given.size
    li_count = pledge.line_items.size

    get :done, {
      :mc_gross => "55.00",
      :invoice => "#{pledge.id}",
      :protection_eligibility => 'Ineligible',
      :item_number1 => "#{saver.id}",
      :item_number2 => "#{storg.id}",
      :payer_id => 'YMQMYSZ5LYANL',
      :tax => '0.00',
      :payment_date => '11-20-07 May 27, 2009 PDT',
      :payment_status => 'Completed',
      :charset => 'windows-1252',
      :mc_shipping => '0.00',
      :mc_handling => '0.00',
      :first_name => 'Test',
      :mc_fee => '1.90',
      :notify_version => '2.8',
      :custom => '',
      :payer_status => 'verified',
      :business => 'tom@savetogether.org',
      :num_cart_items => '2',
      :mc_handling1 => '0.00',
      :mc_handling2 => '0.00',
      :payer_email => 'tom_1233251324_per@savetogether.org',
      :verify_sign => 'AREFmIS0FirenwdngMCN-lqksBYNA668VwpM1h4AHQvdR7JzWkCS4nJ0',
      :mc_shipping1 => '0.00',
      :mc_shipping2 => '0.00',
      :tax1 => '0.00',
      :tax2 => '0.00',
      :txn_id => '86J700648N228641Y',
      :payment_type => 'instant',
      :last_name => 'User',
      :receiver_email => 'tom@savetogether.org',
      :item_name1 => 'samantha',
      :payment_fee => '1.90',
      :item_name2 => 'savetogether',
      :quantity1 => '1',
      :receiver_id => 'ZK62HKKPR4NTE',
      :quantity2 => '1',
      :txn_type => 'cart',
      :mc_currency => 'USD',
      :mc_gross_1 => '50.00',
      :mc_gross_2 => '5.00',
      :residence_country => 'US',
      :test_ipn => '1',
      :transaction_subject => 'Shopping Cart',
      :payment_gross => '55.00',
      :merchant_return_link => 'Return to SaveTogether',
      :auth => 'ZYTlDZ4v57sLTuL7WyZ6m2yqSuVYbjpLtndecieoKRVQMBLnqoLGzVeW0fLuVGIo2x3RJtPa-bB-i7--'
    }

    assert_response :success
    assert_template 'done'

    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > li_count

    donor = Donor.find(donor.id)
    assert donor.donations_given.size > completed_donations
  end

  #test "create valid pledge with logged in user and pledge in session" do
  #  saver = users(:saver)
  #  stOrg = Organization.find_savetogether_org
  #  donor = users(:donor4)
  #  login_as(:donor4)
  #
  #  pledge = Pledge.new(:donation_attributes => pledge_params(saver))
  #  session[:pledge_id] = pledge.id
  #  session[:saver_id] = saver.id
  #
  #  get :continue
  #
  #  assert_response :success
  #  assert_template 'create'
  #
  #  assert session[:pledge_id].nil?
  #
  #  donor = Donor.find(donor.id)
  #  assert !donor.nil?
  #
  #  # Use donor to find pledge and assert they're the same
  #  assert !donor.pledges.empty?
  #  d_pledge = donor.pledges[0]
  #
  #  test_pledge_no_fees(d_pledge)
  #
  #  # Reload pledge and assert it's values
  #  pledge = Pledge.find(d_pledge.id)
  #  assert !pledge.nil?
  #  d_pledge.id == pledge.id
  #
  #  test_pledge_no_fees(pledge)
  #end
end
