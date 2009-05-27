class Donor < User
  has_many :donations, :foreign_key => :donor_id  
end