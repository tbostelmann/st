require File.dirname(__FILE__) + '/../test_helper'

class DonorTest < ActiveSupport::TestCase
  
  def setup
    @good_donor_properties = {
      :login => "foobar",
      :email => "a@b.com",
      :email_confirmation => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago
      }
    @bad_donor_properties = @good_donor_properties.dup
    @bad_donor_properties.delete(:login)
  end
  
  test "complete donor properties are good" do
    donor = Donor.new(@good_donor_properties)
    isValid = donor.valid?
    donor.errors.each {|e, m| puts "Error: #{e} #{m}"}
    assert isValid
  end
  
  test "incomplete donor properties are bad" do
    donor = Donor.new(@bad_donor_properties)
    assert !donor.valid?
  end
  
  test "Donor must have a login" do
    assert false
  end
  
  test "Donor login must be greater than six characters in length" do
    assert false
  end
  
  test "Donor must have an email" do
    assert false
  end
  
  test "Donor email must be confirmed" do
    assert false
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