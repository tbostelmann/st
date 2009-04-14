require 'test_helper'

class DonationLineItemTest < ActiveSupport::TestCase
  test "create donation_line_item" do
    pli = DonationLineItem.new
    assert !pli.valid?

    saver = users(:saver)
    adc = AssetDevelopmentCase.find_by_user_id(saver.id)
    pli.account = adc.account
    assert !pli.valid?

    pli.amount = Money.new(5000)
    assert pli.valid?
  end
end
