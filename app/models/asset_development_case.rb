# == Schema Information
# Schema version: 20090422073021
#
# Table name: asset_development_cases
#
#  id                          :integer(4)      not null, primary key
#  user_id                     :integer(4)
#  organization_id             :integer(4)
#  asset_type_id               :integer(4)
#  requested_match_total_cents :integer(4)
#  requested_match_left_cents  :integer(4)
#  created_at                  :datetime
#  updated_at                  :datetime
#

require 'money'

class AssetDevelopmentCase < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_one :account, :as => :owner
  has_one :asset_type

  composed_of :requested_match_total, :class_name => "Money", :mapping => [%w(requested_match_total_cents cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :organization
  validates_presence_of :user
  validates_presence_of :requested_match_total_cents

  def requested_match_left
    requested_match_total - account.balance
  end
end
