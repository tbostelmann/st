require 'money'

class Donation < ActiveRecord::Base
  has_many :donation_line_items
  has_many :payments
  belongs_to :user

  validates_presence_of :donation_line_items

  def donation_line_item_attributes=(dli_attributes)
    dli_attributes.each do |index, attributes|
      donation_line_items.build(attributes)
    end
  end

  def user_id=(user_id)
    self.user = User.find(user_id)
  end

  def user_id
    self.user.id
  end

  def amount
    amount = Money.new(0)
    self.donation_line_items.each do |dli|   
      amount += dli.amount
    end
    
    return amount
  end
end
