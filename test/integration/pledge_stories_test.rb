require File.dirname(__FILE__) + '/../test_helper'
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
    assert get_pledge.nil?
    email = Faker::Internet.email
    post "/gifts", :gift => {:cents => "100"}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    follow_redirect!
    assert_response :success
    assert_template :edit
    assert_number_gifts(1)
    assert_select "tr.gift", :count => 1

    # update gift amount to a higher value
    put "/gifts/#{get_pledge.gifts[0].id}", :gift => {:cents => "1000", :id => get_pledge.gifts[0].id.to_s}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    follow_redirect!
    assert_response :success
    assert_template :edit
    assert_number_gifts(1)
    assert_select "tr.gift", :count => 1

    # remove gift from pledge
    post "/gifts/delete/#{get_pledge.gifts[0].id.to_s}"
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    follow_redirect!
    assert_response :success
    assert_template :edit
    assert_number_gifts(0)
    assert_select "tr.gift", :count => 0

    # Go back and create one again
    get "/gifts/new"
    assert_response :ok
    assert_template :new

    # Add a gift-card
    email = Faker::Internet.email
    post "/gifts", :gift => {:cents => "100"}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirected_to :controller => :pledges, :action => :render_show_or_edit
    follow_redirect!
    assert_response :success
    assert_template :edit

    # Click 'continue' on pledge page
    post "/pledges/savetogether_ask"
    # Should redirect user to signup or login
    assert_redirected_to :controller => :donors, :action => :signup_or_login
    follow_redirect!
    assert_template :signup_or_login

    # Check that the gift was added to the pledge
    assert_number_gifts(1)

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