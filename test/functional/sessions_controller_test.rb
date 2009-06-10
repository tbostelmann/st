require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "valid login with pledge in session" do
    session[:pledge] = Pledge.new
    session[:saver_id] = '121212'
    post :create, :login => 'donor@example.com', :password => 'test'

    assert_redirected_to :controller => :pledge, :action => :continue
    assert !session[:pledge].nil?
    assert !session[:user].nil?
  end

  test "invalid login with pledge in session" do
    session[:pledge] = Pledge.new
    session[:saver_id] = '121212'
    post :create, :login => 'who?', :password => 'test'

    assert_template :new
    assert !session[:pledge].nil?
  end
end