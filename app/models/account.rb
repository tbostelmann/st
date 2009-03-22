class Account < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  has_many :donation_line_items  
end
