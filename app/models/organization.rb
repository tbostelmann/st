# == Schema Information
# Schema version: 20090422073021
#
# Table name: organizations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Organization < ActiveRecord::Base
  has_one :account, :as => :owner
  has_many :cases

  validates_presence_of :name

  def self.find_savetogether_org
    Organization.find(:first,
            :conditions => "organizations.name = 'SaveTogether'"
            )
  end
end
