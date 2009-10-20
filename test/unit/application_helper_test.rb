require File.dirname(__FILE__) + '/../test_helper'
# require 'money'
include ApplicationHelper

class ApplicationHelperTest < ActiveSupport::TestCase
  
  CENTS_IN_DOLLAR = 100

  test "find_searchable_metro_areas" do
    metro_areas = find_searchable_metro_areas
    all_ma = MetroArea.find(:all)

    assert metro_areas.size <= all_ma.size

    metro_areas.each do |metro_area|
      assert Saver.find(:all, :conditions => {:metro_area_id => metro_area.id}).size > 0
    end
  end
  
  test "Savers pledge menu min is $5" do
    min_spec = 5 * CENTS_IN_DOLLAR
    min_entry = select_pledge_amounts_cents_values.min{|a, b| a[1] <=> b[1]}
    assert_equal min_spec, min_entry[1]
  end

  test "Savers pledge menu default max is $300" do
    max_spec = 300 * CENTS_IN_DOLLAR
    max_entry = select_pledge_amounts_cents_values.max{|a, b| a[1] <=> b[1]}
    assert_equal max_spec, max_entry[1]
  end

  test "Savers pledge menu max may be specified to something besides $300" do
    max_spec = 500 * CENTS_IN_DOLLAR
    max_entry = select_pledge_amounts_cents_values(max_spec).max{|a, b| a[1] <=> b[1]}
    assert_equal max_spec, max_entry[1]
  end
  
  test "Savers pledge menu entries calculated in increments of $25" do
    entries = select_pledge_amounts_cents_values
    25.step(300, 25) do |inc|
      assert_not_nil entries.detect{|e| e[1] == inc * CENTS_IN_DOLLAR}
    end
  end
  
  test "Saver pledge menu can be built for single entry" do
    max_spec = 5 * CENTS_IN_DOLLAR
    entries = select_pledge_amounts_cents_values(max_spec)
    assert_equal 1, entries.size
  end
  
  test "Lower boundary condition: a max amount less than the increment size results in single element of max value" do
    max_spec = 4 * CENTS_IN_DOLLAR
    entries = select_pledge_amounts_cents_values(max_spec)
    assert_equal 1, entries.size
    assert_equal max_spec, entries[0][1]
  end
  
  test "Upper boundary condition: a max amount not modulo(increment_amount) results in last element of max value" do
    max_spec = 6 * CENTS_IN_DOLLAR
    entries = select_pledge_amounts_cents_values(max_spec)
    assert_equal 2, entries.size
    assert_equal max_spec, entries.last[1]
  end

  test "Names can be made possessive" do
    name = "Tommy"
    assert_equal "Tommy's", possessivize(name)
  end
  
  test "Names ending in 's' can be made possessive" do
    name = "James"
    assert_equal "James'", possessivize(name)
  end
  
/
  test "SaveTogether pledge amounts" do
    assert false
  end
/

end