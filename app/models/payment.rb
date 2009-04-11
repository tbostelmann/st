class Payment < ActiveRecord::Base
  belongs_to :donation  
end
