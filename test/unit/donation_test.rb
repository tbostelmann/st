require 'test_helper'
require 'money'

class DonationTest < ActiveSupport::TestCase
  test "create donation" do
    donation = Donation.new()
    assert !donation.valid?

    user = users(:donor)
    donation.user = user
    assert !donation.valid?

    stOrg = Organization.find_savetogether_org
    stOrgDli = DonationLineItem.new(
            :account => stOrg.account,
            :donation => donation)
    donation.donation_line_items << stOrgDli
    assert !donation.valid?

    stOrgDli.amount = Money.new(250)
    assert donation.valid?

    assert donation.amount == Money.new(250)
  end
end
