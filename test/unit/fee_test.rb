require File.dirname(__FILE__) + '/../test_helper'
require 'money'

class FeeTest < ActiveSupport::TestCase
  test "all fees at this point are charged to SaveTogether and go to Paypal" do
    fee = Factory(:fee)
    assert !fee.nil?
    assert !fee.status.nil?
    assert fee.from_user.id == Organization.find_savetogether_org.id
    assert fee.to_user.id == Organization.find_paypal_org.id

    fee2 = Fee.find(fee.id)
    assert !fee2.nil?
    assert !fee2.status.nil?
    assert fee2.from_user.id == fee.from_user.id
    assert fee2.to_user.id == fee.to_user.id
  end
end