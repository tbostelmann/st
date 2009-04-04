class AssetDevelopmentCase < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_one :account, :as => :owner
  has_one :asset_type

  validates_presence_of :organization
  validates_presence_of :user
  validates_presence_of :requested_match_total
  validates_presence_of :requested_match_left
end
