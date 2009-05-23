class Fee < LineItem
  belongs_to :organization, :foreign_key => :user_id
end
