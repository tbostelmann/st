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
end
