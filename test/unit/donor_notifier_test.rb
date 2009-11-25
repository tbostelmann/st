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
    
    @pledge = Pledge.create!(:donor => @donor)
    @pledge.donations << Donation.new(:from_user => @donor, :to_user => users(:deserving_saver_1), :cents => "5000")
    @pledge.donations << Donation.new(:from_user => @donor, :to_user => Organization.find_savetogether_org, :cents => "500")
    @pledge.save!
  end
  
  test "Donor registration email is templated" do
    notification = UserNotifier.create_signup_notification(@donor)
    
    assert_equal "[SaveTogether] Your SaveTogether account has been activated!", notification.subject
    assert_equal @donor.login, notification.to[0]
    assert_match /Hi #{@donor.first_name},/, notification.body
  end
  
  test "Donor thank you email is templated" do
    notification = UserNotifier.create_donation_thanks_notification(@donor, @pledge)
    
    assert_equal "[SaveTogether] Thank you for your donation!", notification.subject
    assert_equal @donor.login, notification.to[0]
    assert_match /Hi #{@donor.first_name},/, notification.body
    assert_match /Thank you for your donation of \$#{@pledge.total_amount}/, notification.body
    assert_match /SaveTogether is a 501\(c\)\(3\) non-profit organization/, notification.body
    assert_match /non-profit organization in good standing with the Internal Revenue Service/, notification.body
    assert_match /no goods or services were provided in exchange for your contribution/, notification.body
    assert_match /federal tax identification number is 26-3455579/, notification.body
    assert_match /Donation Summary:/, notification.body
    assert_match /#{@donor.first_name} #{@donor.last_name}/, notification.body
    # For some reason localization isn't accessible within the ActiveSupport::Test class, not sure what to do about it.
    #formatted_date = l @pledge.created_at, :format => :just_date
    #assert_match /Date: #{formatted_date}/, notification.body
    assert_match /Donation Amount: \$#{@pledge.total_amount}/, notification.body
    assert_match /\*This email serves as your acknowledgment letter for IRS purposes./, notification.body
  end
  
  test "Reset password email is templated" do
    notification = UserNotifier.create_reset_password(@donor)
    
    assert_equal "[SaveTogether] SaveTogether Account information", notification.subject
    assert_equal @donor.login, notification.to[0]
    assert_match /Hi #{@donor.first_name},/, notification.body
    assert_match /Your new password is:/, notification.body
  end
  
end
