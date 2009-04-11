require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  test "create user" do
    user = User.new(
          :login => "samantha",
          :email => "samantha@example.com",
          :description => "Samantha is saving to open her own framing business.",
          :salt => "7e3041ebc2fc05a40c60028e2c4901a81035d3cd",
          :crypted_password => "00742970dc9e6319f8019fd54864d3ea740f04b1", # test
          :state => states(:washington),
          :metro_area => metro_areas(:seattle),
          :birthday => 15.years.ago,
          :role_id => 3,
          :saver => true)
    assert user.valid?
  end

  test "return one saver" do
    user = User.find(:first, :conditions => {:saver => true})
    assert !user.nil?
    assert user.saver?
  end
end