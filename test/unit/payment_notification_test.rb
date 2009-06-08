require File.dirname(__FILE__) + '/../test_helper'

class PaymentNoficiationTest < ActiveSupport::TestCase
  test "create payment notification" do
    pledge = invoices(:pledge2)
    test_pledge_no_fees(pledge)

    li_num = pledge.line_items.size

    storg = users(:savetogether)
    fnum_storg = storg.fees_paid.size

    paypal = users(:paypal)
    fnum_paypal = paypal.fees_received.size

    saver = users(:saver2)
    pn = PaymentNotification.create(:raw_data => "mc_gross=55.00&invoice=#{pledge.id}&protection_eligibility=Ineligible&item_number1=#{saver.id}&item_number2=#{storg.id}&payer_id=YMQMYSZ5LYANL&tax=0.00&payment_date=11%3A20%3A07+May+27%2C+2009+PDT&payment_status=Completed&charset=windows-1252&mc_shipping=0.00&mc_handling=0.00&first_name=Test&mc_fee=1.90&notify_version=2.8&custom=&payer_status=verified&business=tom%40savetogether.org&num_cart_items=2&mc_handling1=0.00&mc_handling2=0.00&payer_email=tom_1233251324_per%40savetogether.org&verify_sign=AREFmIS0FirenwdngMCN-lqksBYNA668VwpM1h4AHQvdR7JzWkCS4nJ0&mc_shipping1=0.00&mc_shipping2=0.00&tax1=0.00&tax2=0.00&txn_id=86J700648N228641Y&payment_type=instant&last_name=User&receiver_email=tom%40savetogether.org&item_name1=samantha&payment_fee=1.90&item_name2=savetogether&quantity1=1&receiver_id=ZK62HKKPR4NTE&quantity2=1&txn_type=cart&mc_currency=USD&mc_gross_1=50.00&mc_gross_2=5.00&residence_country=US&test_ipn=1&transaction_subject=Shopping+Cart&payment_gross=55.00&merchant_return_link=Return+to+SaveTogether&auth=ZYTlDZ4v57sLTuL7WyZ6m2yqSuVYbjpLtndecieoKRVQMBLnqoLGzVeW0fLuVGIo2x3RJtPa-bB-i7--")
    pledge.process_paypal_notification(pn.notification)

    pn = PaymentNotification.find(pn.id)
    assert !pn.notification.nil?
    invoice = pn.notification.invoice
    assert !invoice.nil?
    assert invoice.to_i == pledge.id.to_i

    pledge = Pledge.find(invoice)
    assert !pledge.nil?
    assert pledge.id = invoice.to_i
  end
end