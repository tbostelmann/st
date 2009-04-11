require 'money'

class AssetDevelopmentCase < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_one :account, :as => :owner
  has_one :asset_type

  composed_of :requested_match_total, :class_name => "Money", :mapping => [%w(requested_match_total_cents cents)], :converter => Proc.new { |value| value.to_money }
  composed_of :requested_match_left, :class_name => "Money", :mapping => [%w(requested_match_left_cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :organization
  validates_presence_of :user
  validates_presence_of :requested_match_total_cents
  validates_presence_of :requested_match_left_cents
end
