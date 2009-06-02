require File.dirname(__FILE__) + '/../test_helper'

class DonorTest < ActiveSupport::TestCase
  
  def setup
    @properties_of_valid_cd_user = {
      :login => "foobar",
      :email => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago
      }
  end
  
  test "Donor email must be confirmed" do
    donor = Donor.new(@properties_of_valid_cd_user)
    assert !donor.valid?
    assert donor.errors.on(:email)
    
    @properties_of_valid_cd_user[:email_confirmation] = "foo@bar.com"
    donor = Donor.new(@properties_of_valid_cd_user)
    assert !donor.valid?
    assert donor.errors.on(:email)
    
    @properties_of_valid_cd_user[:email_confirmation] = "a@b.com"
    donor = Donor.new(@properties_of_valid_cd_user)
    assert donor.valid?
  end
  
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
end