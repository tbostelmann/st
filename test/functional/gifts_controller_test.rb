require File.dirname(__FILE__) + '/../test_helper'
require 'faker'

class GiftsControllerTest < ActionController::TestCase
  include ApplicationHelper

  # Replace this with your real tests.
  test "update gift with no pledge should throw RuntimeError" do
    assert_raise(RuntimeError, :runtime_error_no_pledge_in_session.l) {
        post :update, :id => "999999", :gift => {:cents => "200"}}
  end

  test "update gift that is not in current pledge should throw ArgumentError" do
    get_or_init_pledge
    assert_raise(ArgumentError, :argument_error_line_item_not_in_current_pledge.l(:id => "999999")) {
      post :update, :id => "999999", :gift => {:cents => "200"}}
  end

  test "update gift that doesnt have status of null should throw SecurityError" do
    pledge = Factory(:pending_pledge_with_gift)
    session[:pledge_id] = pledge.id
    assert_raise(SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => pledge.gifts[0].id, :status => pledge.gifts[0].status)) {
      post :update, :id => pledge.gifts[0].id, :gift => {:cents => "20000"}}
  end

  test "create gift with no pledge should work" do
    email = Faker::Internet.email
    post :create, :gift => {:cents => "2000", :to_user_id => Organization.find_giftcard_org.id}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    pledge = get_pledge
    gifts = pledge.gifts
    assert !gifts.nil?
    assert gifts.size == 1
    assert gifts[0].gift_card.email == email
  end

  test "create gift forces to_user to be giftcard_org" do
    email = Faker::Internet.email
    post :create, :gift => {:cents => "2000", :to_user_id => Saver.find_random_active(:first).id}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    assert get_pledge.gifts[0].to_user_id = Organization.find_giftcard_org.id
  end

  test "update gift forces to_user to be giftcard_org" do
    email = Faker::Internet.email
    post :create, :gift => {:cents => "2000", :to_user_id => Saver.find_random_active(:first).id}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    assert get_pledge.gifts[0].to_user_id = Organization.find_giftcard_org.id
  end

  test "delete existing gift in pledge should work" do
    pledge = Factory(:anonymous_unpaid_pledge)
    gift = Factory(:anonymous_unpaid_gift, :invoice => pledge)
    pledge = Pledge.find(pledge.id)
    assert pledge.gifts.size == 1
    session[:pledge_id] = pledge.id
    post :delete, :id => gift.id
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    pledge = Pledge.find(pledge.id)
    assert pledge.gifts.size == 0
  end

  test "delete a gift that is not in the current pledge should throw an ArgumentError" do
    get_or_init_pledge
    assert_raise(ArgumentError, :argument_error_line_item_not_in_current_pledge.l(:id => "999999")) {
      post :delete, :id => "999999"}
  end

  test "delete gift that doesnt have status of null should throw SecurityError" do
    pledge = Factory(:pending_pledge_with_gift)
    session[:pledge_id] = pledge.id
    assert_raise(SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => pledge.gifts[0].id, :status => pledge.donations[0].status)) {
      post :delete, :id => pledge.gifts[0].id}
  end

  test "delete gift with no pledge should not work RuntimeError" do
    assert_raise(RuntimeError, :runtime_error_no_pledge_in_session.l) {
        post :delete, :id => "999999"}
  end

  test "get new gift should respond successfully with the new template" do
    get :new
    assert_response_new_template(:gifts)
  end
end
