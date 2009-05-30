# == Schema Information
# Schema version: 20090422073021
#
# Table name: invoices
#
#  id                 :integer(4)      not null, primary key
#  type               :string(255)
#  notification_email :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Invoice < ActiveRecord::Base
  has_many :line_items
  belongs_to :donor 

  def self.process_payment_notification(pn)
    notify = pn.notification
    invoice = Invoice.find(notify.invoice)

    if invoice.nil?
      raise "Invoice not found"
    end

    Invoice.transaction do
      if notify.acknowledge
        # Verify Donation values against payment notification values
        # Then update status
        index = 1
        while item_number = notify.params["item_number#{index}"]
          beneficiary = User.find(item_number)
          if beneficiary.nil?
            raise "Beneficiary of Donation with id=#{beneficiary.id}, referenced in the payment notification, is not found"
          end

          amount = notify.params["amount#{index}"]
          line_item = line_items.find_by_to_user(beneficiary)
          if (line_item.nil?)
            raise "LineItem for user #{beneficiary.id} not found"
          elsif (amount.to_f != line_item.amount.to_f)
            raise "LineItem.amount=#{line_item.amount} does not equal reported amount of #{amount}"
          end

          line_item.status = notify.status
          index = index + 1
        end

        # Verify that the reported number of LineItems matches Invoice's Donation size
        reported_size = index - 1   # Remove trailing increase of index
        donations = line_items.find_by_type(:donation)
        unless reported_size == donations.size
          raise "Reported LineItem count does not match Invoice LineItem count"
        end

        # Add reported Fee if it hasn't been reported already'
        amount = notify.fee
        paypal = Organization.find_paypal_org
        fee = line_items.find_by_to_user(paypal)
        if fee.nil?
          storg = Organization.find_savetogether_org
          invoice.line_items << Fee.create(:from_user => storg, :to_user => paypal,
                  :amount => amount, :invoice => invoice, :status => notify.status)
        elsif fee.amount.to_f != amount.to_f
          raise "Report Fee has changed since last notification"
        else
          fee.status = notify.status
        end

        invoice.set_transaction_status(pn, notify.status)
      else
        return false
      end
    end

    return true
  end
end
