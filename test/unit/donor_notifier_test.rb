require File.dirname(__FILE__) + '/../test_helper'

class DonorNotifierTest < ActiveSupport::TestCase
  def setup
    @donor = Donor.new({:first_name => "Newt",
    :last_name => "Donor",
    :login => "foo@bar.com",
    :login_confirmation => "foo@bar.com",
    :password => "foo2thebar",
    :password_confirmation => "foo2thebar",
    :birthday => 21.years.ago
    })
    @donor.save!
  end
  
  test "Donor registration email is templated" do
    notification = UserNotifier.create_signup_notification(@donor)
    
    assert_equal "[SaveTogether] Your SaveTogether account has been activated!", notification.subject
    assert_equal @donor.login, notification.to[0]
    assert_match /Hi #{@donor.first_name},/, notification.body
  end
  
  test "Donor thank you email is templated" do
    notification = UserNotifier.create_donation_thanks_notification(@donor)
    
    assert_equal "[SaveTogether] Thank you for your donation!", notification.subject
    assert_equal @donor.login, notification.to[0]
    assert_match /Hi #{@donor.first_name},/, notification.body
  end
  
end
