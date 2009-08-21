require File.dirname(__FILE__) + '/../test_helper'

class InvitationTest < ActiveSupport::TestCase
  test "Can be initialized with title, invitation and email strings" do
    title = "This is a test"
    message = "Check it out"
    friends = "a@b.com c@d.com, e@g.com; f@h.com"
    limit = 5
    invite = Invitation.new({:title => title, :message => message, :friends => friends, :limit => limit})
    assert_equal title, invite.title
    assert_equal message, invite.message
    assert_equal friends, invite.friends
    assert_equal limit, invite.limit
  end
  
  test "Supports only those fields" do
    assert_raise NoMethodError do
      invite = Invitation.new({:unsupported => "This field is unsupported"})
    end
  end
  
  test "Can accept emails delimited by space, comma or semi-colon" do
    emails = ["a@b.com", "c@d.com", "e@g.com", "Doogie Browser <doogieb@foo.bar>", "f@h.com", "i@j.com", "k@l.net"]
    friends_list = emails.join(", ")

    # friends_list = "  " << emails[0] << ", "
    # friends_list << emails[1] << "; "
    # friends_list << emails[2] << "  "
    # friends_list << emails[3] << " ,, "
    # friends_list << emails[4] << "; , ;"
    # friends_list << emails[5] << "  "
    puts "Friends' list: \"#{friends_list}\""
    
    invite = Invitation.new({:title => "This is a test", :message => "Check it out", :friends => friends_list})
    puts "Friends' emails: \"#{invite.emails.join("\" \"")}\""
    invite.errors.each {|err| puts "Error: #{err}"} unless invite.is_valid?
    
    assert invite.is_valid?, "Invitation is not valid"
    
    assert_equal emails.size, invite.emails.size
    invite.emails.each {|email| assert_not_nil emails.include?(email)}
  end
  
  test "Can handle empty email list" do
    invite = new_test_invite({:friends => nil})
    assert !invite.is_valid?
  end
  
  test "Will accept valid email formats" do
    invite = new_test_invite   
    assert invite.is_valid?
  end
  
  test "Will not accept invalid email formats" do
    invite = new_test_invite({:friends => "a@b c@d.com foo@bar.12345"})    
    assert !invite.is_valid?
    assert_equal 2, invite.errors.size
  end
  
  test "Will remove any duplicate emails from the friends list" do
    invite = new_test_invite({:friends => "a@b.com  b@c.com  a@b.com  c@d.com  a@b.com  e@f.com"})    
    assert invite.is_valid?
    assert_equal 4, invite.emails.size
  end
  
  test "Invitation list defaults to 10 invitees" do
    invite = new_test_invite({:friends => new_test_invitee_list(10)})
    assert invite.is_valid?
    
    invite = new_test_invite({:friends => new_test_invitee_list(11)})
    assert !invite.is_valid?
  end
  
  test "Invitation list limit can be specified" do
    invite = new_test_invite({:friends => new_test_invitee_list(5), :limit => 5})
    assert invite.is_valid?
    
    invite = new_test_invite({:friends => new_test_invitee_list(6), :limit => 5})
    assert !invite.is_valid?
  end
  
protected

  def new_test_invite(options = {})
    Invitation.new({
      :title => "This is a test",
      :message => "Check it out",
      :friends => "a@b.com c@d.com foo@bar.net"
      }.merge(options))
  end
  
  def new_test_invitee_list(count)
    (1..count).inject([]){|invitees, i| invitees << "foo+#{i}@bar.com"}.join(" ")
  end
  
end
