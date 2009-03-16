require 'money'

class Donation < ActiveRecord::Base
  has_many :donation_line_items
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :donation_line_items

  def amount
    amount = Money.new(0)
    self.donation_line_items.each do |dli|   
      amount += dli.amount
    end
    
    return amount
  end
end
