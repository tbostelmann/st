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
