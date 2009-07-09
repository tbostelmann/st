require File.dirname(__FILE__) + '/../test_helper'
# require 'money'
include ApplicationHelper

class ApplicationHelperTest < ActiveSupport::TestCase
  
  CENTS_IN_DOLLAR = 100
  
  test "Savers pledge menu min is $25" do
    min_spec = 25 * CENTS_IN_DOLLAR
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
    max_spec = 25 * CENTS_IN_DOLLAR
    entries = select_pledge_amounts_cents_values(max_spec)
    assert_equal 1, entries.size
  end
  
  test "Lower boundary condition: a max amount less than the increment size results in single element of max value" do
    max_spec = 24 * CENTS_IN_DOLLAR
    entries = select_pledge_amounts_cents_values(max_spec)
    assert_equal 1, entries.size
    assert_equal max_spec, entries[0][1]
  end
  
  test "Upper boundary condition: a max amount not modulo(increment_amount) results in last element of max value" do
    max_spec = 30 * CENTS_IN_DOLLAR
    entries = select_pledge_amounts_cents_values(max_spec)
    assert_equal 2, entries.size
    assert_equal max_spec, entries.last[1]
  end

/
  test "SaveTogether pledge amounts" do
    assert false
  end
/

end