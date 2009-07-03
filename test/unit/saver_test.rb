require File.dirname(__FILE__) + '/../test_helper'

class SaverTest < ActiveSupport::TestCase
  test "get the list of donations_received" do
    saver = users(:saver)
    assert saver.all_donations_received.size == 1
    assert saver.donations_received.size == 1
    saver.all_donations_received.each do |d|
      assert d.class == Donation
    end

    saver2 = users(:saver2)
    assert saver2.all_donations_received.size == 1
    assert saver2.donations_received.size == 0
    saver2.all_donations_received.each do |d|
      assert d.class == Donation
    end

    saver3 = users(:saver3)
    assert saver3.all_donations_received.size == 2
    assert saver3.donations_received.size == 0
    saver3.all_donations_received.each do |d|
      assert d.class == Donation
    end
  end

  test "get saver matched percentage" do
    saver = users(:saver)
    assert saver.match_percent > 0

    saver2 = users(:saver2)
    assert saver2.match_percent == 0

    saver3 = users(:saver3)
    assert saver3.match_percent == 0
  end
end