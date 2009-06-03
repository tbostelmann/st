# == Schema Information
# Schema version: 20090422073021
#
# Table name: invoices
#
#  id                 :integer(4)      not null, primary key
#  donor_id           :integer(4)
#  type               :string(255)
#  notification_email :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Pledge < Invoice
  belongs_to :donor 

  def donation_attributes=(d_attributes)
    d_attributes.each do |index, attributes|
      donations.build(attributes)
    end
  end

  def process_paypal_notification(notify)
    # Verify Donation values against payment notification values
    # Then update status
    index = 1
    while item_number = notify.params["item_number#{index}"]
      saver = User.find(item_number)
      if saver.nil?
        raise "Beneficiary of Donation with id=#{saver.id}, referenced in the payment notification, is not found"
      end

      amount = notify.params["mc_gross_#{index}"]
      line_item = self.donations.find(:first, :conditions => {:to_user_id => saver.id})
      if (line_item.nil?)
        raise "LineItem for user #{saver.id} not found"
      elsif (amount.to_f != line_item.amount.to_s.to_f)
        raise "LineItem.amount=#{line_item.amount} does not equal reported amount of #{amount}"
      end

      line_item.status = notify.status
      index = index + 1
    end

    # Verify that the reported number of LineItems matches Invoice's Donation size
    reported_size = index - 1   # Remove trailing increase of index
    unless reported_size == self.donations.size
      raise "Reported LineItem count does not match Invoice Donation count"
    end

    # Add reported Fee if it hasn't been reported already'
    amount = notify.fee
    paypal = Organization.find_paypal_org
    fee = self.fees.find(:first, :conditions => {:to_user_id => paypal})
    if fee.nil?
      storg = Organization.find_savetogether_org
      self.fees << Fee.new(:from_user => storg, :to_user => paypal,
              :amount => amount, :status => notify.status)
    elsif fee.amount.to_s.to_f != amount.to_f
      raise "Fee amount has changed since last notification"
    else
      fee.status = notify.status
    end
  end
end
