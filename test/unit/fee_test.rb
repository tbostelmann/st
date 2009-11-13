require File.dirname(__FILE__) + '/../test_helper'
require 'money'

class FeeTest < ActiveSupport::TestCase
  test "all fees at this point are charged to SaveTogether and go to Paypal" do
    fee = Factory(:fee)
    assert !fee.nil?
    assert fee.from_user.id == Organization.find_savetogether_org.id
    assert fee.to_user.id == Organization.find_paypal_org.id
  end
end