require File.dirname(__FILE__) + '/../test_helper'

class DonorTest < ActiveSupport::TestCase
  test "Donor email is off-limits to direct manipulation" do
    assert_raise RuntimeError do
      donor = new_test_donor(:email => "a@b.com")
    end
  end
  
  # there are a host of other email format checks that for now we'll just leverage
  # the fact that they are verified in the CE tests (doesn't protect our expectations
  # from changes in CE code, though)
  test "Donor login is now email and must follow email formating rules" do
    donor = new_test_donor(:login => "a@b..com", :login_confirmation => "a@b..com")
    assert !donor.valid?
    assert donor.errors.on(:login)
    assert_equal donor.login, donor.email
  end

  test "Donor login confirmation is required" do
    donor = new_test_donor({:login => "a@b.com", :login_confirmation => ""})
    assert !donor.valid?
    assert donor.errors.on(:login)

    donor = new_test_donor({:login => "a@b.com", :login_confirmation => "foo@bar.com"})
    assert !donor.valid?
    assert donor.errors.on(:login)

    donor = new_test_donor({:login => "a@b.com", :login_confirmation => "a@b.com"})
    assert donor.valid?
  end
    
  test "Donor login and email are the same" do
    donor = new_test_donor(:login => "a@b.com", :login_confirmation => "a@b.com")
    assert donor.valid?
    assert_equal donor.login, donor.email
  end
  
  test "Donor must have a first name" do
    donor = new_test_donor(:first_name => nil)
    assert !donor.valid?
    assert donor.errors.on(:first_name)
  end

  test "Donor must have a last name" do
    donor = new_test_donor(:last_name => nil)
    assert !donor.valid?
    assert donor.errors.on(:last_name)
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
    assert donor2.donations_given.size == 0
    donor.all_donations_given.each do |d|
      assert d.class == Donation
    end

    donor3 = users(:donor3)
    assert donor3.all_donations_given.size == 3
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
  
  protected
  
  def new_test_donor(options = {})
    Donor.new({
      :first_name => "Newt",
      :last_name => "Donor",
      :login => "a@b.com",
      :login_confirmation => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago
      }.merge(options))
  end

end
