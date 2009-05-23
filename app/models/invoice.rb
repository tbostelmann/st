class Invoice < ActiveRecord::Base
  has_many :line_items
  has_one :pledge
end
