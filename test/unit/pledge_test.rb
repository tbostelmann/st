require File.dirname(__FILE__) + '/../test_helper'
require 'money'

class PledgeTest < ActiveSupport::TestCase
  test "validate donation" do
    pledge = invoices(:pledge)
    assert !pledge.nil?
  end

  test "donation requires notification email" do
    pledge = Pledge.new
    assert !pledge.valid?

    pledge.notification_email = 'a@b.com'
    assert pledge.valid?
  end

  test "notification email format must be valid" do
    pledge = Pledge.new
    pledge.notification_email = 'a@b.com'
    assert pledge.valid?

    # Must supply an account on the domain
    pledge.notification_email = "@b.com"
    assert !pledge.valid?

    # Top-level domain is required
    pledge.notification_email = "a@b"
    assert !pledge.valid?

    # Organization domain is required
    pledge.notification_email = "a@.com"
    assert !pledge.valid?

    # @ is required
    pledge.notification_email = "a.b.com"
    assert !pledge.valid?

    # domain must be at least 2 chars
    pledge.notification_email = "a@b.c"
    assert !pledge.valid?

    pledge.notification_email = "a@b.cc"
    assert pledge.valid?

    # Multiple domain separators not allowed in sequence
    pledge.notification_email = "a@b..com"
    assert !pledge.valid?

    # Sub-organizational domains allowed
    pledge.notification_email = "a@foo.bar.com"
    assert pledge.valid?

    # validation doesn't check for validity of top-level domain
    pledge.notification_email = "a@b.joe"
    assert pledge.valid?
  end
end
