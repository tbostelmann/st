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

  def update_user(user)
    self.user = user
    unless line_items.empty?
      line_items.each do |line_item|
        line_item.donor = user
      end
    end
  end

  def self.process_payment_notification(pn)
    notify = pn.notification
    invoice = Invoice.find(notify.invoice)

    if notify.acknowledge
      if invoice.line_items.empty?
        invoice.populate_invoice(notify)
      end

      invoice.set_transaction_status(pn, notify.status)
    else
      return false
    end

    return invoice.save
  end

  private

  def set_transaction_status(pn, status)
    line_items.each do |line_item|
      FinancialTransaction.create(
              :payment_notification => pn, :line_item => line_item, :status => status)
      line_item.status = status
      line_item.save
    end
  end

  def populate_invoice(notify)
    index = 1
    while item_number = notify.params["item_number#{index}"]
      amount = notify.params["amount#{index}"]
      beneficiary = User.find(item_number)
      invoice.line_items << Donation.create(:donor => user, :user => beneficiary,
              :amount => amount, :invoice => invoice, :status => notify.status)
      index = index + 1
    end
    amount = notify.fee
    if amount.to_f > 0
      storg = Organization.find_savetogether_org
      invoice.line_items << Fee.create(:user => storg, :amount => amount,
              :invoice => invoice, :status => notify.status)
    end
  end
end
