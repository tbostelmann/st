require 'test_helper'
require 'money'

class DonationTest < ActiveSupport::TestCase
  
  def setup
    @anon_donation = Pledge.new
    @anon_donation.saver = users(:saver)
    @anon_donation.notification_email = "a@b.com"
    
    account = Organization.find_savetogether_org.account
    
    @amounts = [100, 150]
    @amounts.each do |amt|
      dli = DonationLineItem.new(:account => account, :donation => @test_donation, :amount => Money.new(amt))
      @anon_donation.donation_line_items << dli
    end
    
  end
  
  test "validate donation" do
    donation = donations(:donor_donation)
    assert !donation.nil?  
  end

  test "donation may be anonymous" do
    assert @anon_donation.valid?
  end

  test "donor may choose to be identified" do
    assert @anon_donation.valid?
    
    @anon_donation.user = users(:donor)
    assert @anon_donation.valid?
  end
  
  test "donation requires saver" do
    assert @anon_donation.valid?
    
    @anon_donation.saver = nil
    assert !@anon_donation.valid?
  end
  
  test "donation requires status" do
    assert @anon_donation.valid?
    
    @anon_donation.donation_status = nil
    assert !@anon_donation.valid?
  end
  
  test "donation requires notification email" do
    assert @anon_donation.valid?
    
    @anon_donation.notification_email = nil
    assert !@anon_donation.valid?
  end
  
  test "notification email length must be less than a maximum" do
    # control: a@b.com
    at_domain_init = "@b.co"
    @anon_donation.notification_email = ("a" << at_domain_init)
    assert @anon_donation.valid?
    
    long_email = ""
    (100 - at_domain_init.size).times { long_email << "x" }
    long_email << at_domain_init
    
    # 100 characters is valid
    @anon_donation.notification_email = long_email
    assert @anon_donation.valid?
    
    # > 100 characters is not
    @anon_donation.notification_email << "m"
    assert !@anon_donation.valid?
  end
  
  test "notification email format must be valid" do
    # control: a@b.com
    assert @anon_donation.valid?
    
    # Must supply an account on the domain
    @anon_donation.notification_email = "@b.com"
    assert !@anon_donation.valid?
    
    # Top-level domain is required
    @anon_donation.notification_email = "a@b"
    assert !@anon_donation.valid?
    
    # Organization domain is required
    @anon_donation.notification_email = "a@.com"
    assert !@anon_donation.valid?
    
    # @ is required
    @anon_donation.notification_email = "a.b.com"
    assert !@anon_donation.valid?
    
    # domain must be at least 2 chars
    @anon_donation.notification_email = "a@b.c"
    assert !@anon_donation.valid?
    
    @anon_donation.notification_email = "a@b.cc"
    assert @anon_donation.valid?
    
    # Multiple domain separators not allowed in sequence
    @anon_donation.notification_email = "a@b..com"
    assert !@anon_donation.valid?
    
    # Sub-organizational domains allowed
    @anon_donation.notification_email = "a@foo.bar.com"
    assert @anon_donation.valid?
    
    # validation doesn't check for validity of top-level domain
    @anon_donation.notification_email = "a@b.joe"
    assert @anon_donation.valid?
  end
  
  test "donation requires line items" do
    assert @anon_donation.valid?
    
    @anon_donation.donation_line_items.clear
    assert !@anon_donation.valid?
  end
  
  test "donation amount is the sum of it's line items" do
    assert_equal(Money.new(@amounts.sum), @anon_donation.amount)
  end
end
