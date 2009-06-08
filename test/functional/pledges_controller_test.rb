require File.dirname(__FILE__) + '/../test_helper'

class PledgesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  test "get new" do
    saver = users(:saver)
    get :new, {:saver_id => saver.id}
    assert_template 'new'
    assert_response :success
  end

  test "create valid donation with logged in user should render create template" do
    saver = users(:saver)
    stOrg = Organization.find_savetogether_org
    donor = users(:donor4)
    login_as(:donor4)

    post :create, {
        :saver_id => saver.id,
        :pledge => { :donation_attributes => pledge_params(saver) }}

    assert_template 'create'
    assert_response :success

    donor = Donor.find(donor.id)
    assert !donor.nil?

    # Use donor to find pledge and assert they're the same
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]

    test_pledge_no_fees(d_pledge)

    # Reload pledge and assert it's values
    pledge = Pledge.find(d_pledge.id)
    assert !pledge.nil?
    d_pledge.id == pledge.id

    test_pledge_no_fees(pledge)
  end

  test "complete a pledge using an IPN" do
    pledge = invoices(:pledge2)
    saver = users(:saver2)
    storg = Organization.find_savetogether_org
    donor = users(:donor2)

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
  end
#  test "create action on invalid donation should render 'new' template" do
#    adc = asset_development_cases(:saverCase)
#    saver = users(:saver)
#    stOrg = Organization.find_savetogether_org
#
#    incomplete_param_list = gimme_some_donation_params
#    incomplete_param_list.delete(:saver_id)
#
#    post :create, :donation => incomplete_param_list
#
#    assert_template 'new'
#    assert_response :success
#  end
#
end
