# == Schema Information
# Schema version: 20091117074908
#
# Table name: asset_types
#
#  id         :integer(4)      not null, primary key
#  asset_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AssetType < ActiveRecord::Base
  has_many :savers

  def to_s
    asset_name
  end
end
