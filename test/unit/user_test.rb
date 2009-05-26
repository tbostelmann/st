require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  test "test create user" do
    user = User.new(
          :login => "samantha",
          :email => "samantha@example.com",
          :description => "Samantha is saving to open her own framing business.",
          :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
          :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
          :state => states(:washington),
          :metro_area => metro_areas(:seattle),
          :birthday => 15.years.ago,
          :role_id => 3)
    assert user.valid?
  end

  test "get the list of donations from a saver" do
    saver = users(:saver)
    assert saver.donations.size > 0
  end

  test "get saver matched percentage" do
    saver = users(:saver)
    assert saver.match_percent > 0

    saver2 = users(:saver2)
    assert saver2.match_percent == 0
  end
end