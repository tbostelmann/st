require File.dirname(__FILE__) + '/../test_helper'
require 'benchmark'
include Benchmark

class SaverTest < ActiveSupport::TestCase
  test "successful_saver?" do
    saver = users(:saver_success_story)
    assert saver.is_successful_saver?

    saver = users(:saver)
    assert !saver.is_successful_saver?
  end

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
    assert saver.match_percentage > 0

    saver2 = users(:saver2)
    assert saver2.match_percentage == 0

    saver3 = users(:saver3)
    assert saver3.match_percentage == 0
  end
  
  test "more than 4 featured savers can be requested" do  
    assert_equal 5, Saver.find_random(:all, :limit => 5).size
  end
  
  test "less than 4 featured savers can be requested" do
    assert_equal 3, Saver.find_random(:all, :limit => 3).size
  end
  
  test "requesting more featured savers than savers returns all savers" do
    count_all = Saver.find(:all).size
    assert_equal count_all, Saver.find_random(:all, :limit => count_all+1).size
  end
  
  test "requesting one saver returns exactly one saver" do
    assert_equal 1, Saver.find_random(:all, :limit => 1).size
  end
  
  test "featured savers should be random" do
    # we'll say in ten calls, there should be some difference in the first
    # elements of the returned set, and call that good (and random). We
    # don't simply compare the results of two calls, because with only four
    # elements, it's highly likely this unit test would see aperiodic failure.
    
    itsrandom = false
    
    first_first_position = Saver.find_random(:all, :limit => 4)[1]
    (2..10).each{ itsrandom ||= Saver.find_random(:all, :limit => 4)[1] != first_first_position }
    
    assert itsrandom
  end
  
  # test "featured savers should be fast" do
  #   puts "About to benchmark featured savers"
  #   
  #   bmbm(100) do |b|
  #     b.report("fs sort_by") {Saver.featured_savers(4, "enumerable")}
  #     b.report("fs sort")    {Saver.featured_savers(4, "array")}
  #   end
  #   
  #   puts "Completed benchmarking featured savers"
  # end
end