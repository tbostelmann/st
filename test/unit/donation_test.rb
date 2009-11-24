require File.dirname(__FILE__) + '/../test_helper'
require 'money'

class DonationTest < ActiveSupport::TestCase
#  test "donation may be anonymous" do
#    assert @anon_pledge.valid?
#  end
#
#  test "donor may choose to be identified" do
#    assert @anon_donation.valid?
#
#    @anon_donation.user = users(:donor)
#    assert @anon_donation.valid?
#  end
#
#  test "donation requires saver" do
#    assert @anon_donation.valid?
#
#    @anon_donation.saver = nil
#    assert !@anon_donation.valid?
#  end
#
#  test "donation requires status" do
#    assert @anon_donation.valid?
#
#    @anon_donation.donation_status = nil
#    assert !@anon_donation.valid?
#  end

  def setup
    @donor = users(:donor)
    @saver = users(:saver)
    @storg = users(:savetogether)
    @pledge = Pledge.create!
  end

  test "Donation to saver may be greater than zero" do
    donation = Donation.new(:from_user_id => @donor.id, :to_user_id => @saver.id, :cents => "#{100}", :invoice => @pledge)
    assert donation.valid?
  end
  
  test "Donation to saver may not be zero" do
    donation = Donation.new(:from_user_id => @donor.id, :to_user_id => @saver.id, :cents => "#{0}", :invoice => @pledge)
    assert !donation.valid?
  end
  
  test "Donation to saver may not be less than zero" do
    donation = Donation.new(:from_user_id => @donor.id, :to_user_id => @saver.id, :cents => "#{-100}", :invoice => @pledge)
    assert !donation.valid?
  end
  
  test "Donation to SaveTogether may be greater than zero" do
    donation = Donation.new(:from_user_id => @donor.id, :to_user_id => @storg.id, :cents => "#{100}", :invoice => @pledge)
    assert donation.valid?
  end
  
  test "Donation to SaveTogether may be zero" do
    donation = Donation.new(:from_user_id => @donor.id, :to_user_id => @storg.id, :cents => "#{0}", :invoice => @pledge)
    assert donation.valid?
  end
  
  test "Donation to SaveTogether may not be less than zero" do
    donation = Donation.new(:from_user_id => @donor.id, :to_user_id => @storg.id, :cents => "#{-100}", :invoice => @pledge)
    assert !donation.valid?
  end
end
