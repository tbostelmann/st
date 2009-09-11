require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "check find_paypal_org" do
    paypal = Organization.find_paypal_org
    assert !paypal.nil?
    assert paypal.login == Organization::PAYPAL_LOGIN
  end

  test "check find_savetogether_org" do
    storg = Organization.find_savetogether_org
    assert !storg.nil?
    assert storg.login == Organization::SAVETOGETHER_LOGIN
  end
  
  test "get collection of partners" do
    partners = Organization.find_partners
    partners.each do |p|
      assert p.login != Organization::SAVETOGETHER_LOGIN
      assert p.login != Organization::PAYPAL_LOGIN
    end
  end

  test "find_random_savers" do
    org = users(:earn)

    savers = org.find_random_savers(1)

    assert !savers.nil?
    assert savers[0].organization.id == org.id

    savers = org.find_random_savers(2)
    assert savers.size == 2
  end
end
