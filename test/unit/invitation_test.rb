require File.dirname(__FILE__) + '/../test_helper'

class InvitationTest < ActiveSupport::TestCase
  test "Can be initialized with title, invitation and email strings" do
    title = "This is a test"
    message = "Check it out"
    friends = "a@b.com c@d.com, e@g.com; f@h.com"
    invite = Invitation.new({:title => title, :message => message, :friends => friends})
    assert_equal title, invite.title
    assert_equal message, invite.message
    assert_equal friends, invite.friends
  end
  
  test "Supports only those fields" do
    assert_raise NoMethodError do
      invite = Invitation.new({:unsupported => "This field is unsupported"})
    end
  end
  
  test "Can accept emails delimited by space, comma or semi-colon" do
    emails = ["a@b.com", "c@d.com", "e@g.com", "f@h.com", "i@j.com", "k@l.net"]

    friends_list = "" << emails[0] << ", "
    friends_list << emails[1] << "; "
    friends_list << emails[2] << "  "
    friends_list << emails[3] << " ,, "
    friends_list << emails[4] << "; , ;"
    friends_list << emails[5]
    #puts "Friends' list: \"#{friends_list}\""
    
    invite = Invitation.new({:title => "This is a test", :message => "Check it out", :friends => friends_list})
    #puts "Friends' emails: \"#{fn.email_list.join("\" \"")}\""
    
    email_list = invite.email_list
    assert_equal emails.size, email_list.size
    email_list.each {|email| assert_not_nil emails.include? email}
  end
  
  test "Will accept valid email formats" do
    emails = "a@b.com c@d.com foo@bar.net"
    invite = Invitation.new({:title => "This is a test", :message => "Check it out", :friends => emails})
    
    assert invite.is_valid?
  end
  
  test "Will not accept invalid email formats" do
    emails = "a@b c@d.com foo@bar.12345"
    invite = Invitation.new({:title => "This is a test", :message => "Check it out", :friends => emails})
    
    assert !invite.is_valid?
    assert_equal 2, invite.errors.size
  end
  
end
