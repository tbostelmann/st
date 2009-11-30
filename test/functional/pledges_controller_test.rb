require File.dirname(__FILE__) + '/../test_helper'

class PledgesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    # allows you to inspect email notifications 
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end
  
  test "go to savetogether ask page not logged in" do
    pledge = invoices(:pledge)
    session[:pledge_id] = pledge.id

    get :savetogether_ask

    assert_redirected_to signup_or_login_path
  end

  test "go to savetogether ask page logged in" do
    login_as(:donor3)
    pledge = invoices(:pledge4)
    session[:pledge_id] = pledge.id

    get :savetogether_ask
    assert_response :success
    assert_template :savetogether_ask
  end
  
  test "get cancel" do
    get :cancel
    assert_response :success
    assert_template :cancel
  end

  test "complete a pledge using an IPN" do
    pledge = invoices(:pledge2)
    saver = users(:saver2)
    storg = Organization.find_savetogether_org
    donor = users(:donor2)

    completed_donations = donor.donations_given.size
    li_count = pledge.line_items.size

    post :notify, create_ipn(pledge)

    assert_response :success

    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > li_count

    donor = Donor.find(donor.id)
    assert donor.donations_given.size > completed_donations
  end

  test "complete a pledge when returning to st site" do
    pledge = invoices(:pledge2)
    donor = users(:donor2)
    login_as(:donor2)

    completed_donations = donor.donations_given.size
    li_count = pledge.line_items.size

    get :done, create_ipn(pledge)

    assert_redirected_to :controller => "donor_surveys", :action => "show", :thank_you_for_pledge => true
    assert_not_nil assigns['pledge']
    assert flash[:thank_you_for_pledge]

    pledge = Pledge.find(pledge.id)
    assert pledge.line_items.size > li_count

    donor = Donor.find(donor.id)
    assert donor.donations_given.size > completed_donations
    
    assert_equal 1, @emails.size
    assert_equal "[SaveTogether] Thank you for your donation!", @emails[0].subject
  end

  test "handle an ipn with no fee" do
    pledge = invoices(:pledge2)
    donor = users(:donor2)
    login_as(:donor2)

    completed_donations = donor.donations_given.size
    li_count = pledge.line_items.size

    get :done, create_notification(pledge)

    assert_redirected_to :controller => "donor_surveys", :action => "show", :thank_you_for_pledge => true
    assert_not_nil assigns['pledge']
    assert flash[:thank_you_for_pledge]

    pledge = Pledge.find(pledge.id)
    # Make sure there weren't any added line_items - fees
    assert pledge.line_items.size == li_count

    donor = Donor.find(donor.id)
    assert donor.donations_given.size > completed_donations

    assert_equal 1, @emails.size
    assert_equal "[SaveTogether] Thank you for your donation!", @emails[0].subject
  end
end
