class AssetDevelopmentCase < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_one :account, :as => :owner

  validates_presence_of :organization
  validates_presence_of :user
  validates_presence_of :account
end
