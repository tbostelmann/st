require 'test_helper'

class GiftsControllerTest < ActionController::TestCase
  include ApplicationHelper

  # Replace this with your real tests.
  test "update gift with no pledge should throw RuntimeError" do
    assert_raise(RuntimeError, :runtime_error_no_pledge_in_session.l) {
        post :update, :gift => {:id => "999999", :cents => "200"}}
  end

  test "update a gift with no parameter values should throw ArgumentError" do
    assert_raise(ArgumentError,
                 :argument_error_no_class_params_supplied.l) {post :update}
  end

  test "update gift that is not in current pledge should throw ArgumentError" do
    get_or_init_pledge
    assert_raise(ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => "999999")) {
      post :update, :gift => {:id => "999999", :cents => "200"}}
  end

  test "update gift that doesnt have status of null should throw SecurityError" do
    pledge = Factory(:pending_pledge_with_gift)
    session[:pledge_id] = pledge.id
    assert_raise(SecurityError, :security_error_trying_to_update_processed_gift.l(:id => pledge.gifts[0].id)) {
      post :update, :gift => {:id => pledge.gifts[0].id, :cents => "20000"}}
  end

  test "create gift with no pledge should work" do
    pledge = Factory(:anonymous_unpaid_pledge)
    assert pledge.gifts.nil? || pledge.gifts.size == 0
    session[:pledge_id] = pledge.id
    post :create, :gift => {:cents => "2000"}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    pledge = Pledge.find(pledge.id)
    assert pledge.gifts.size == 1
  end

  test "delete existing gift in pledge should work" do
    pledge = Factory(:anonymous_unpaid_pledge)
    gift = Factory(:anonymous_unpaid_gift)
    pledge.add_line_item(gift)
    pledge.save!
    pledge = Pledge.find(pledge.id)
    assert pledge.gifts.size == 1
    session[:pledge_id] = pledge.id
    post :delete, :gift => {:id => gift.id}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    pledge = Pledge.find(pledge.id)
    assert pledge.gifts.size == 0
  end

  test "create gift with no parameter values should throw ArgumentError" do
    assert_raise(ArgumentError,
                 :argument_error_no_class_params_supplied.l) {post :create}
  end

  test "delete gift with no parameter valeus should throw ArgumentError" do
    assert_raise(ArgumentError,
                 :argument_error_no_class_params_supplied.l) {post :create}
  end

  test "delete a gift that is not in the current pledge should throw an ArgumentError" do
    get_or_init_pledge
    assert_raise(ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => "999999")) {
      post :delete, :gift => {:id => "999999"}}
  end

  test "delete gift that doesnt have status of null should throw SecurityError" do
    pledge = Factory(:pending_pledge_with_gift)
    session[:pledge_id] = pledge.id
    assert_raise(SecurityError, :security_error_trying_to_update_processed_gift.l(:id => pledge.gifts[0].id)) {
      post :delete, :gift => {:id => pledge.gifts[0].id}}
  end

  test "delete gift with no pledge should not work RuntimeError" do
    assert_raise(RuntimeError, :runtime_error_no_pledge_in_session.l) {
        post :delete, :gift => {:id => "999999"}}
  end

  test "get new gift should respond successfully with the new template" do
    get :new
    assert_response :success
    assert_template :new
  end
end
