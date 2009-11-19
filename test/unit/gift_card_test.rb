require 'test_helper'

class GiftCardTest < ActiveSupport::TestCase
  test "create gift_card using factories" do
    pledge = Factory(:anonymous_unpaid_pledge_with_gift)
    gc = Factory(:gift_card, :gift => pledge.gifts[0])
    gift = Gift.find(pledge.gifts[0].id)
    assert gift.id == gc.gift.id
  end
end
