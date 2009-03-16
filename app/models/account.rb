class Account < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  belongs_to :donation_line_item
end
