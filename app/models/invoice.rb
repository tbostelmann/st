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

class Invoice < ActiveRecord::Base
  has_many :line_items, :foreign_key => :invoice_id
  has_many :donations, :foreign_key => :invoice_id
  has_many :fees, :foreign_key => :invoice_id
  belongs_to :donor 

  def self.process_payment_notification?(pn, acknowledge = false)
    notify = pn.notification
    invoice = Invoice.find(notify.invoice)

    if invoice.nil?
      raise "Invoice not found"
    end

    Invoice.transaction do
      if notify.acknowledge || acknowledge
        # Verify Donation values against payment notification values
        # Then update status
        index = 1
        while item_number = notify.params["item_number#{index}"]
          beneficiary = User.find(item_number)
          if beneficiary.nil?
            raise "Beneficiary of Donation with id=#{beneficiary.id}, referenced in the payment notification, is not found"
          end

          amount = notify.params["mc_gross_#{index}"]
          line_item = invoice.line_items.find(:first, :conditions => {:to_user_id => beneficiary})
          if (line_item.nil?)
            raise "LineItem for user #{beneficiary.id} not found"
          elsif (amount.to_f != line_item.amount.to_s.to_f)
            raise "LineItem.amount=#{line_item.amount} does not equal reported amount of #{amount}"
          end

          line_item.status = notify.status
          index = index + 1
        end

        # Verify that the reported number of LineItems matches Invoice's Donation size
        reported_size = index - 1   # Remove trailing increase of index
        unless reported_size == invoice.donations.size
          raise "Reported LineItem count does not match Invoice Donation count"
        end

        # Add reported Fee if it hasn't been reported already'
        amount = notify.fee
        paypal = Organization.find_paypal_org
        fee = invoice.fees.find(:first, :conditions => {:to_user_id => paypal})
        if fee.nil?
          storg = Organization.find_savetogether_org
          invoice.line_items << Fee.create(:from_user => storg, :to_user => paypal,
                  :amount => amount, :invoice => invoice, :status => notify.status)
        elsif fee.amount.to_f != amount.to_f
          raise "Report Fee has changed since last notification"
        else
          fee.status = notify.status
        end
      else
        return false
      end
    end

    return true
  end

  def line_item_attributes=(li_attributes)
    li_attributes.each do |index, attributes|
      line_items.build(attributes)
    end
  end
end
