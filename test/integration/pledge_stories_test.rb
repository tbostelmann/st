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

    post "/donations/create",
        :donation => {:cents => "10000", :to_user_id => saver.id}
    assert_redirect_show_or_edit_then_edit_template :donations => 1, :gifts => 0
  end

  test "Make a gift card and checkout" do
    get "/gifts/new"
    assert_response_new_template(:gifts)

    # Create a new gift card
    assert get_pledge.nil?
    email = Faker::Internet.email
    post "/gifts", :gift => {:cents => "100"}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirect_show_or_edit_then_edit_template :gifts => 1, :donations => 0

    # update gift amount to a higher value
    put "/gifts/#{get_pledge.gifts[0].id}", :gift => {:cents => "1000", :id => get_pledge.gifts[0].id.to_s}
    assert_redirect_show_or_edit_then_edit_template :gifts => 1, :donations => 0
    # TODO: assert new gift amount value

    # remove gift from pledge
    post "/gifts/delete/#{get_pledge.gifts[0].id.to_s}"
    assert_redirect_show_or_edit_then_edit_template :gifts => 0, :donations => 0

    # Go back and create one again
    get "/gifts/new"
    assert_response_new_template(:gifts)

    # Add a gift-card
    email = Faker::Internet.email
    post "/gifts", :gift => {:cents => "100"}, :gift_card =>
            {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :email => email,
             :email_confirmation => email, :message => Populator.sentences(2..10)}
    assert_redirect_show_or_edit_then_edit_template :gifts => 1, :donations => 0

    # Click 'continue' on pledge page
    post "/pledges/savetogether_ask"
    # Should redirect user to signup or login
    assert_redirect_signup_or_login_template

    email = Faker::Internet.email
    password = "randomepassword"
    post "/donors", :donor => {:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, 
                                :login => email, :login_confirmation => email,
                                :password => password, :password_confirmation => password, :profile_public => true}
    assert_redirect_savetogether_ask_template :gifts => 1, :donations => 0

    user = Donor.find(session[:user])
    post "/donations/create",
        :donation => {:from_user_id => user.id, :cents => "10000", :to_user_id => Organization.find_savetogether_org.id}
    assert_redirect_show_or_edit_then_show_template :gifts => 1, :donations => 1

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