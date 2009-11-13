require 'test_helper'

class GiftControllerTest < ActionController::TestCase
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

  test "update gift that doesnt have status of null should throw ArgumentError" do
    pledge = Factory(:pending_pledge_with_gift)
    assert_raise(SecurityError, :security_error_trying_to_update_processed_gift.l(:id => pledge.gifts[0].id)) {
      post :update, :gift => {:id => pledge.gifts[0].id, :cents => "20000"}}
  end
end
