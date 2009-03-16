require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def test_create_account
    account = Account.new()
    assert account.valid?
  end
end
