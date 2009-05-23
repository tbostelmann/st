class Donation < LineItem
  belongs_to :saver, :foreign_key => :user_id
end
