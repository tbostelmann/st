require File.dirname(__FILE__) + '/../test_helper'

class DonorTest < ActiveSupport::TestCase
  test "get the list of donations_given" do
    donor = users(:donor)
    assert donor.all_donations_given.size == 2
    assert donor.donations_given.size == 2
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end

    donor2 = users(:donor2)
    assert donor2.all_donations_given.size == 2
    assert donor2.donations_given.size == 2
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end

    donor3 = users(:donor3)
    assert donor3.all_donations_given.size == 2
    assert donor3.donations_given.size == 0
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end
  end

  test "get a list of savers that the donor has given to" do
    donor = users(:donor)
    beneficiaries = donor.beneficiaries
    assert !beneficiaries.empty?
    assert beneficiaries.size > 0
    beneficiaries.each do |party|
      assert party.class == Saver
    end
  end
end