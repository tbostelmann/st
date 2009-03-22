require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "create organization" do
    org = Organization.new()
    assert !org.valid?

    org = Organization.new(
            :account => Account.new())
    assert !org.valid?

    org = Organization.new(
            :name => "Test Org")
    assert org.valid?

    org = Organization.new(
            :name => "Test Org",
            :account => Account.new())
    assert org.valid?
  end

  test "find SaveTogether org" do
    stOrg = Organization.find_savetogether_org
    assert !stOrg.nil?
    assert !stOrg.account.nil?
  end
end
