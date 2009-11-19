require 'test_helper'
require 'faker'

class PledgeStoriesTest < ActionController::IntegrationTest
  include ApplicationHelper
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

  test "Make a gift card and checkout" do
    get "/gifts/new"
    assert_response :ok
    assert_template :new

    # Create a new gift card
    # TODO: add first_name, last_name, email, message to giftee
    assert get_pledge.nil?
    email = Faker::Internet.email
    post "/gifts/create", :gift => {:cents => "2000"}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    follow_redirect!
    assert_response :success
    assert_template :edit

    # Check that the gift was added to the pledge
    pledge = get_pledge
    assert !pledge.nil?
    assert pledge.gifts.size == 1

    # Check that the tag was tag was rendered
    assert_select "tr.gift", :count => 1
    
    # Click 'continue' on pledge page
    # should respond with savetogether_ask

    # Add savetogether donation
    # should respond with pledge page that includes paypal link

    # skip over paypal stuff..
    # post instant payment notification stuff for pledge to done
    # should respond with thank you page

    # thank you message should be sent to donor

    # gift card message should be sent to giftee
  end

  test "Giftee returns to site by clicking on link in email" do
    # giftee clicks on link in email
    # pledge should be created and gift should be added to pledge
    # TODO: do we need to guide the user through the site?

    # giftee chooses a saver
    # should respond with showing pledge page
    # amount from gift should negate from gift

    # click 'continue' on pledge page
    # should respond with pledge page that includes paypal link

    #TODO: need to figure out how to handle left over gift amount
  end
end