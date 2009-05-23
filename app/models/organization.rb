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

class Organization < User
  has_many :savers
  has_many :fees

  def self.find_savetogether_org
    Organization.find(:first,
            :conditions => {:login => 'savetogether'}
            )
  end
end
