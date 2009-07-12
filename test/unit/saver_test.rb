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
  
  test "featured savers should default to 4" do
    assert_equal 4, Saver.featured_savers.size
  end
  
  test "more than 4 featured savers can be requested" do
    requested = 5
    assert_equal requested, Saver.featured_savers(requested).size
  end
  
  test "less than 4 featured savers can be requested" do
    requested = 3
    assert_equal requested, Saver.featured_savers(requested).size
  end
  
  test "requesting more featured savers than savers returns all savers" do
    count_all = Saver.find(:all).size
    assert_equal count_all, Saver.featured_savers(count_all+1).size
  end
  
  test "requesting less than one saver returns exactly one saver" do
    assert_equal 1, Saver.featured_savers(-1).size
  end
  
  test "featured savers should be random" do
    # we'll say in ten calls, there should be some difference in the first
    # elements of the returned set, and call that good (and random). We
    # don't simply compare the results of two calls, because with only four
    # elements, it's highly likely this unit test would see aperiodic failure.
    
    itsrandom = false
    
    first_first_position = Saver.featured_savers[0]
    (2..10).each{ itsrandom ||= Saver.featured_savers[0] != first_first_position }
    
    assert itsrandom
  end
end