require 'test_helper'

class GiftTest < ActiveSupport::TestCase
  test "create gift using factory" do
    pledge = Factory(:pledge)
    gift = Factory(:anonymous_unpaid_gift, :invoice => pledge)
    gift = Gift.find(gift.id)
    assert !gift.gift_card.nil?
  end
end
