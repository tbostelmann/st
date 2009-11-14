require File.dirname(__FILE__) + '/../test_helper'
require 'money'

class PledgeTest < ActiveSupport::TestCase

  test "create unpaid factory pledge" do
    pledge = Factory(:anonymous_unpaid_pledge)
    pledge = Pledge.find(pledge.id)
    pledge.line_items.each do |li|
      assert li.status.nil?
    end
  end

  test "create pending factory pledge" do
    pledge = Factory(:pending_pledge)
    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > 0
    assert pledge.donations.size > 0
    pledge.line_items.each do |li|
      assert li.status == LineItem::STATUS_PENDING
    end
  end

  test "create completed factory pledge" do
    pledge = Factory(:completed_pledge)
    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > 0
    assert pledge.donations.size > 0
    assert pledge.fees.size > 0
    pledge.line_items.each do |li|
      assert li.status == LineItem::STATUS_COMPLETED
    end
  end

  test "create pending factory pledge with gift" do
    pledge = Factory(:pending_pledge_with_gift)
    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > 0
    assert pledge.donations.size > 0
    assert pledge.gifts.size > 0
    pledge.line_items.each do |li|
      assert li.status == LineItem::STATUS_PENDING
    end
  end

  test "find donation with same to_user_id" do
    pledge = invoices(:pledge)
    donation = pledge.donations[0]
    d = pledge.find_donation_with_to_user_id(donation.to_user_id)
    assert d.to_user_id == donation.to_user_id    
  end

  test "add donation to pledge" do
    pledge = invoices(:pledge)
    donation = pledge.donations[0]
    donation.amount = "500.00"
    pledge.add_donation(donation)
    d = pledge.find_donation_with_to_user_id(donation.to_user_id)
    assert d.amount = donation.amount
  end
  
  test "cannot add nil donation to pledge" do
    pledge = invoices(:pledge)
    assert_nothing_raised(NoMethodError) {
      pledge.add_donation(nil)
    }
  end

  test "remove donation from pledge" do
    pledge = invoices(:pledge)
    donation = pledge.donations[0]
    pledge.remove_donation_with_to_user_id(donation.to_user_id)
    assert !pledge.find_donation_with_to_user_id(donation.to_user_id)
  end

  test "get total amount of donations from pledge" do
    saver = users(:saver)
    donor = users(:donor)
    pledge = Pledge.new(:donor => donor)
    amount = "10.00"
    donation = Donation.new(:invoice => pledge, :from_user => donor,
                            :to_user => saver, :amount => amount)
    pledge.donations << donation
    pledge.save!
    pledge = Pledge.find(pledge.id)

    total = pledge.total_amount_for_donations.to_s.to_f
    assert pledge.total_amount_for_donations.to_s.to_f == amount.to_f
  end

  test "create initial, pending pledge" do
    donor = users(:donor4)
    saver = users(:saver4)
    pledge = Pledge.new(:donor => donor)
    pledge.donations << Donation.new(:from_user => donor, :to_user => saver, :amount => "50")
    pledge.donations << Donation.new(:from_user => donor, :to_user => Organization.find_savetogether_org, :amount => "5")  
    pledge.save

    # Reload pledge and assert it's values
    pledge = Pledge.find(pledge.id)
    assert !pledge.nil?

    test_pledge_no_fees(pledge)

    # Use donor to find pledge and assert they're the same
    donor = Donor.find(donor.id)
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]
    d_pledge.id == pledge.id

    test_pledge_no_fees(d_pledge)
  end

  test "create initial, pending pledge using donation_attribures=" do
    donor = users(:donor4)
    saver = users(:saver4)
    pledge = Pledge.create(:donor => donor)
    pledge.donation_attributes= pledge_params(saver)
    pledge.donations.each do |donation|
      donation.from_user = donor
    end
    saved = pledge.save
    assert saved
    pledge = Pledge.find(pledge.id)

    # Reload pledge and assert it's values
    pledge = Pledge.find(pledge.id)
    assert !pledge.nil?

    test_pledge_no_fees(pledge)

    # Use donor to find pledge and assert they're the same
    donor = Donor.find(donor.id)
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]
    d_pledge.id == pledge.id

    test_pledge_no_fees(d_pledge)
  end

  test "applying a payment_notification to a pending invoice" do
    pledge = invoices(:pledge2)
    test_pledge_no_fees(pledge)

    li_num = pledge.line_items.size

    storg = users(:savetogether)
    fnum_storg = storg.fees_paid.size

    paypal = users(:paypal)
    fnum_paypal = paypal.fees_received.size

    saver = users(:saver2)
    pn = PaymentNotification.create(:raw_data => "mc_gross=55.00&invoice=#{pledge.id}&protection_eligibility=Ineligible&item_number1=#{saver.id}&item_number2=#{storg.id}&payer_id=YMQMYSZ5LYANL&tax=0.00&payment_date=11%3A20%3A07+May+27%2C+2009+PDT&payment_status=Completed&charset=windows-1252&mc_shipping=0.00&mc_handling=0.00&first_name=Test&mc_fee=1.90&notify_version=2.8&custom=&payer_status=verified&business=tom%40savetogether.org&num_cart_items=2&mc_handling1=0.00&mc_handling2=0.00&payer_email=tom_1233251324_per%40savetogether.org&verify_sign=AREFmIS0FirenwdngMCN-lqksBYNA668VwpM1h4AHQvdR7JzWkCS4nJ0&mc_shipping1=0.00&mc_shipping2=0.00&tax1=0.00&tax2=0.00&txn_id=86J700648N228641Y&payment_type=instant&last_name=User&receiver_email=tom%40savetogether.org&item_name1=samantha&payment_fee=1.90&item_name2=savetogether&quantity1=1&receiver_id=ZK62HKKPR4NTE&quantity2=1&txn_type=cart&mc_currency=USD&mc_gross_1=50.00&mc_gross_2=5.00&residence_country=US&test_ipn=1&transaction_subject=Shopping+Cart&payment_gross=55.00&merchant_return_link=Return+to+SaveTogether&auth=ZYTlDZ4v57sLTuL7WyZ6m2yqSuVYbjpLtndecieoKRVQMBLnqoLGzVeW0fLuVGIo2x3RJtPa-bB-i7--")
    pledge.process_paypal_notification(pn.notification)

    # Assert that we have the additional line_item (fee)
    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > li_num

    storg = Organization.find(storg.id)
    assert storg.fees_paid.size > fnum_storg

    paypal = Organization.find(paypal.id)
    assert paypal.fees_received.size > fnum_paypal
  end
  
  test "suggested donations calculate correctly" do
    test_percent = 0.17
    test_cents   = 500
    expected_result = Money.new(test_cents.to_f * test_percent)
    donation = Donation.suggest_percentage_of(1, 2, test_percent, Money.new(test_cents))
    assert_equal donation.cents, expected_result.cents
  end
  
  test "donations sorted for display result in ST donation at end" do

    pledge = initialize_test_pledge
    # pledge.donations.each_with_index {|d, i| p "sorted donations test: before: d[#{i}]: id:#{d.id}, to_user_id:#{d.to_user_id}"}

    assert pledge.donations_sorted_for_display.last.to_user_id == @storg.id
    # pledge.donations_sorted_for_display.each_with_index {|d, i| p "sorted donations test: after, before save: d[#{i}]: id:#{d.id}, to_user_id:#{d.to_user_id}"}

    # Not required, but required for reasonable sorting of non-ST donations
    pledge.save!

    assert pledge.donations_sorted_for_display.last.to_user_id == @storg.id
    # pledge.donations_sorted_for_display.each_with_index {|d, i| p "sorted donations test: after, after save: d[#{i}]: id:#{d.id}, to_user_id:#{d.to_user_id}"}
  end
  
  test "billable donations don't include any zero-dollar donations" do
    pledge = initialize_test_pledge(0)
    # ensure donations include at zero-dollar donation - ensures last assert is meaningful
    assert pledge.donations.reject{|d| !d.amount.zero?}.size == 1
    # The rule under test:
    pledge.billable_donations.each{|d| assert !d.amount.zero?}
  end
  
  test "billable donations are one less than donations including a zero-dollar ST donation" do
    pledge = initialize_test_pledge(0)
    assert_equal pledge.donations.size, pledge.billable_donations.size + 1
  end
  
  test "billable donations are size equivalent to donations that include non-zero ST donation" do
    pledge = initialize_test_pledge
    assert_equal pledge.donations.size, pledge.billable_donations.size
  end
  
  test "billable donations are one less than sorted donations including a zero-dollar ST donation" do
    pledge = initialize_test_pledge(0)
    assert_equal pledge.donations_sorted_for_display.size, pledge.billable_donations.size + 1
  end
  
  test "billable donations are size-equivalent to sorted donations that include non-zero ST donation" do
    pledge = initialize_test_pledge
    assert_equal pledge.donations_sorted_for_display.size, pledge.billable_donations.size
  end
  
  def initialize_test_pledge(st_ask=100)
    @donor  = users(:donor)
    @saver1 = users(:saver)
    @saver2 = users(:saver2)
    @saver3 = users(:saver3)
    @saver4 = users(:saver4)
    @storg  = users(:savetogether)
    
    pledge = Pledge.new
    pledge.add_donation Donation.suggest_percentage_of(@donor.id, @storg.id,  100.0, Money.new(st_ask))
    pledge.add_donation Donation.suggest_percentage_of(@donor.id, @saver1.id, 100.0, Money.new(100))
    pledge.add_donation Donation.suggest_percentage_of(@donor.id, @saver2.id, 100.0, Money.new(100))
    pledge.add_donation Donation.suggest_percentage_of(@donor.id, @saver3.id, 100.0, Money.new(100))
    pledge.add_donation Donation.suggest_percentage_of(@donor.id, @saver4.id, 100.0, Money.new(100))
    
    pledge
  end
  
end
