require 'test_helper'

class GiftCardTest < ActiveSupport::TestCase
  test "create gift_card using factories" do
    pledge = Factory(:anonymous_unpaid_pledge_with_gift)
    gc = Factory(:gift_card, :gift_from => pledge.gifts[0])
    gift = Gift.find(pledge.gifts[0].id)
    assert gift.id == gc.gift_from.id
  end
end
