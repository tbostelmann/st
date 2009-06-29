require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  
  test "simple login" do
    donor = users(:donor)
    post :create, :login => donor.login, :password => 'test'
    
    assert_response :redirect
    assert_redirected_to :controller => :donors, :action => donor.id
  end

  test "valid login with pledge in session" do
    session[:pledge_id] = invoices(:pledge).id
    session[:saver_id] = '121212'
    post :create, :login => 'donor@example.com', :password => 'test'

    assert_redirected_to :controller => :pledges, :action => :savetogether_ask
    assert !session[:pledge_id].nil?
    assert !session[:user].nil?
  end

  test "invalid login with pledge in session" do
    session[:pledge_id] = invoices(:pledge).id
    session[:saver_id] = '121212'
    post :create, :login => 'who?', :password => 'test'

    assert_template :new
    assert !session[:pledge_id].nil?
  end
  
end