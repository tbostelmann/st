require 'test_helper'

class PledgeStoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "Full donation cycle for basic pledge with one donation" do
    saver = Factory(:saver)

    get "/match-savers/"
    assert_response :success
    assert_template :index

    get "/savers/#{saver.id}"
    assert_response :success
    assert_template :show

    post "/pledges/add_to_pledge",
        :donation => {:cents => "10000", :to_user_id => saver.id}
    assert_response :success
    assert_template :edit
  end

end