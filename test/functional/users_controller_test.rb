require 'test_helper'

class UsersControllerTest < ActionController::TestCase
#  test "Test create user with no donation_id" do
#    put :create, :user => {
#            :login => 'testuser', :email => 'test@domain.com',
#            :password => 'testuserpassword', :password_confirmation => 'testuserpassword'}
#    assert_redirected_to signup_completed_user_path(:testuser)
#  end
#
#  test "Test create user with donation_id set to empty string" do
#    put :create, :donation_id => "", :user => {
#            :login => 'testuser', :email => 'test@domain.com',
#            :password => 'testuserpassword', :password_confirmation => 'testuserpassword'}
#    assert_redirected_to signup_completed_user_path(:testuser)
#  end
#
#  test "Test create user with donation_id set" do
#    donation = donations(:anonymous_donation)
#    put :create, :donation_id => donation.id, :user => {
#            :login => 'testuser', :email => 'test@domain.com',
#            :password => 'testuserpassword', :password_confirmation => 'testuserpassword'}
#    assert_redirected_to signup_completed_user_path(:testuser)
#    user = User.find_by_login('testuser')
#    donations = user.donations
#    donation = Pledge.find(donation.id)
#    assert !donation.user.nil?
#  end  

#    assert_redirected_to donation_path(assigns(:donation))
#  end
#
#  def test_should_show_donation
#    get :show, :id => donations(:one).id
#    assert_response :success
#  end
#
#  def test_should_get_edit
#    get :edit, :id => donations(:one).id
#    assert_response :success
#  end
#
#  def test_should_update_donation
#    put :update, :id => donations(:one).id, :donation => { }
#    assert_redirected_to donation_path(assigns(:donation))
#  end
#
#  def test_should_destroy_donation
#    assert_difference('Donation.count', -1) do
#      delete :destroy, :id => donations(:one).id
#    end
#
#    assert_redirected_to donations_path
#  end
end
