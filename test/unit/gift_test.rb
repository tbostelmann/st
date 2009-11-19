require 'test_helper'

class GiftTest < ActiveSupport::TestCase
  test "create gift using factory" do
    gift = Factory(:anonymous_unpaid_gift)
    gift = Gift.find(gift.id)
    assert !gift.gift_card.nil?
  end
end
