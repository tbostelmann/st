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

class Saver < User
  belongs_to :organization
  has_many :donations
  has_one :asset_type

  composed_of :requested_match_amount, :class_name => "Money", :mapping => [%w(cents requested_match_cents)], :converter => Proc.new { |value| value.to_money }

  validates_presence_of :organization
  validates_presence_of :requested_match_cents
  validates_presence_of :asset_type

  #two methods to return money amounts with $ prefix and without cents
  def total_amt_display
    return  Money.us_dollar(requested_match_total_cents).format(:no_cents);
  end

  def match_left_display
    amt_left = requested_match_total-account.balance
    return Money.us_dollar(amt_left.cents).format(:no_cents);
  end

  def match_left
    requested_match_total - account.balance
  end
  
  def match_percent
    blnce = account.cents
    rmt = requested_match_total_cents
    if blnce > 0
      perc = blnce.to_f / rmt.to_f
      return perc
    else
      return 0
    end
  end
end
