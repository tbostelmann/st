require File.dirname(__FILE__) + '/../test_helper'
require 'faker'

class DonationsControllerTest < ActionController::TestCase
  include ApplicationHelper

  # Replace this with your real tests.
  test "update donation with no pledge should throw RuntimeError" do
    assert_raise(RuntimeError, :runtime_error_no_pledge_in_session.l) {
        post :update, :donation => {:id => "999999", :cents => "200"}}
  end

  test "update a donation with no parameter values should throw ArgumentError" do
    assert_raise(ArgumentError,
                 :argument_error_no_class_params_supplied.l) {post :update}
  end

  test "update donation that is not in current pledge should throw ArgumentError" do
    get_or_init_pledge
    assert_raise(ArgumentError, :argument_error_line_item_not_in_current_pledge.l(:id => "999999")) {
      post :update, :donation => {:id => "999999", :cents => "200"}}
  end

  test "update donation that doesnt have status of null should throw SecurityError" do
    pledge = Factory(:pending_pledge)
    session[:pledge_id] = pledge.id
    assert_raise(SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => pledge.donations[0].id, :status => pledge.donations[0].status)) {
      post :update, :donation => {:id => pledge.donations[0].id, :cents => "20000"}}
  end

  test "create donation with no pledge should work" do
    assert get_pledge.nil?
    saver = Factory(:saver)
    email = Faker::Internet.email
    post :create, :donation => {:cents => "2000", :to_user_id => saver.id}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    pledge = get_pledge
    assert pledge.donations.size == 1
  end

  test "delete existing donation in pledge should work" do
    pledge = Factory(:anonymous_unpaid_pledge)
    assert pledge.donations.size == 2
    donation = pledge.donations[0]
    session[:pledge_id] = pledge.id
    post :delete, :id => donation.id
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    pledge = get_pledge
    assert pledge.donations.size == 1
  end

  test "create donation with no parameter values should throw ArgumentError" do
    assert_raise(ArgumentError,
                 :argument_error_no_class_params_supplied.l) {post :create}
  end

  test "delete donation with no parameter valeus should throw ArgumentError" do
    assert_raise(ArgumentError,
                 :argument_error_no_class_params_supplied.l) {post :create}
  end

  test "delete a donation that is not in the current pledge should throw an ArgumentError" do
    get_or_init_pledge
    assert_raise(ArgumentError, :argument_error_line_item_not_in_current_pledge.l(:id => "999999")) {
      post :delete, :id => "999999"}
  end

  test "delete donation that doesnt have status of null should throw SecurityError" do
    pledge = Factory(:pending_pledge)
    session[:pledge_id] = pledge.id
    assert_raise(SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => pledge.donations[0].id, :status => pledge.donations[0].status)) {
      post :delete, :id => pledge.donations[0].id}
  end

  test "delete donation with no pledge should not work RuntimeError" do
    assert_raise(RuntimeError, :runtime_error_no_pledge_in_session.l) {
        post :delete, :donation => {:id => "999999"}}
  end
end
