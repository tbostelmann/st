require File.dirname(__FILE__) + '/../test_helper'
require 'money'

class PledgeTest < ActiveSupport::TestCase
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

    test_pledge(pledge)

    # Use donor to find pledge and assert they're the same
    donor = Donor.find(donor.id)
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]
    d_pledge.id == pledge.id

    test_pledge(d_pledge)
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

    test_pledge(pledge)

    # Use donor to find pledge and assert they're the same
    donor = Donor.find(donor.id)
    assert !donor.pledges.empty?
    d_pledge = donor.pledges[0]
    d_pledge.id == pledge.id

    test_pledge(d_pledge)
  end
end
