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
  
  test "donors can register as anonymous" do
    
    count_donor_space
    
    new_test_donor(:first_name => "Anonymous", :anonymous => true).save!

    assert_equal @orig_all_donors_count + 1, Donor.find(:all).size,
      "Total number of donors didn't increase as expected with addition of anonymous donor"
    assert_equal @orig_public_donors_count, Donor.find_all_by_anonymous(false).size,
      "Total number of public donors increased unexpectedly with addition of anonymous donor"
    assert_equal @orig_anonymous_donors_count + 1, Donor.find_all_by_anonymous(true).size,
      "Total number of anonymous donors didn't increase as expected with addition of anonymous donor"
  end
  
  test "public donors can update their profile to become anonymous" do
    
    count_donor_space
    
    public_donor = Donor.find_by_profile_public(true)
    public_donor.anonymous = true
    public_donor.save!
    
    assert_equal @orig_all_donors_count, Donor.find(:all).size,
      "Total number of donors increased unexpectedly with update of public donor to anonymous"
    assert_equal @orig_public_donors_count - 1, Donor.find_all_by_anonymous(false).size,
      "Total number of public donors remained stable unexpectedly with update of public donor to anonymous"
    assert_equal @orig_anonymous_donors_count + 1, Donor.find_all_by_anonymous(true).size,
      "Total number of anonymous donors didn't increase as expected with update of public donor to anonymous"
  end
  
  test "anonymous donors can update their profiles to become public" do
    
    count_donor_space
    
    anonymous_donor = Donor.find_by_profile_public(false)
    anonymous_donor.anonymous = false
    anonymous_donor.save!
    
    assert_equal @orig_all_donors_count, Donor.find(:all).size,
      "Total number of donors increased unexpectedly with update of public donor to anonymous"
    assert_equal @orig_public_donors_count + 1, Donor.find_all_by_anonymous(false).size,
      "Total number of public donors didn't increase as expected with update of anonymous donor to public"
    assert_equal @orig_anonymous_donors_count - 1, Donor.find_all_by_anonymous(true).size,
      "Total number of anonymous donors remained stable unexpectedly with update of anonymous donor to public"
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
  
  test "donors can summarize donation history" do
    donor = users(:generous_donor)
    donations_grouped_by_beneficiaries = donor.donations_grouped_by_beneficiaries

    test_groups = donor.donations_given.find(:all).group_by{ |donation| donation.to_user }
    
    assert_equal test_groups.size, donations_grouped_by_beneficiaries.size,
      "Expected number of beneficiaries differs from test groups"

    test_groups.keys.each do |bene|
      assert_equal test_groups[bene].size, donations_grouped_by_beneficiaries[bene].size,
        "Expected number of donations for a beneficiary differs from test group"
    end
    
    test_groups.keys.each do |bene|
      assert_equal test_groups[bene].collect(&:cents).sum, donations_grouped_by_beneficiaries[bene].collect(&:cents).sum,
        "Expected sum of donations for a beneficiary differs from test group"
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
      :birthday => 21.years.ago,
      :role => Role[:member]
      }.merge(options))
  end
  
  def count_donor_space
    @orig_all_donors_count       = Donor.find(:all).size
    @orig_public_donors_count    = Donor.find_all_by_anonymous(false).size
    @orig_anonymous_donors_count = Donor.find_all_by_anonymous(true).size
  end

end
