require 'test_helper'

class AssetDevelopmentCaseTest < ActiveSupport::TestCase
  def test_create_asset_development_case
    adc = AssetDevelopmentCase.new()
    assert !adc.valid?

    user = users(:minUser)
    adc.user = user
    assert !adc.valid?

    org = organizations(:minOrganization)
    adc.organization = org
    assert !adc.valid?

    adc.requested_match_total_cents = 2000 * 100
    adc.requested_match_left_cents = 500 * 100
    assert adc.valid?
  end

  def test_lookup_asset_development_case
    user = users(:saver)
    adc = AssetDevelopmentCase.find_by_user_id(user.id)
    assert !adc.nil?
  end
end
