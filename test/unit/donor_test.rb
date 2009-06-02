require File.dirname(__FILE__) + '/../test_helper'

class DonorTest < ActiveSupport::TestCase
  
  test "Donor email must be confirmed" do
    donor = create_a_donor({:email => "a@b.com", :email_confirmation => nil})
    assert !donor.valid?
    assert donor.errors.on(:email)
    
    donor = create_a_donor({:email => "a@b.com", :email_confirmation => "foo@bar.com"})
    assert !donor.valid?
    assert donor.errors.on(:email)
    
    donor = create_a_donor({:email => "a@b.com", :email_confirmation => "a@b.com"})
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

  protected
    def create_a_donor(options = {})
      Donor.new({
        :login => "foobar",
        :email => "a@b.com",
        :email_confirmation => "a@b.com",
        :password => "foo2thebar",
        :password_confirmation => "foo2thebar",
        :birthday => 21.years.ago
        }.merge(options))
    end

end
