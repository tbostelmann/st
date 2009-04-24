# == Schema Information
# Schema version: 20090422073021
#
# Table name: asset_types
#
#  id         :integer(4)      not null, primary key
#  asset_name :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class AssetType < ActiveRecord::Base
end
