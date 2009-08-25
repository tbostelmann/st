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
  
  test "Will accept regular and friendly email formats" do
    invite = mock_test_invite({:friends => "a@b.com, c@d.net, Doogie Browser <doogieb@foobar.org>"})
    assert invite.is_valid?
  end
  
  test "Friendly formatted email can include most characters in friendly part" do
    crazy_but_valid_friendly_name = '123.45:-_={}~67890!@#$%^&*()\' <pathological@case.net>'
    # puts "Pathological case: #{crazy_but_valid_friendly_name}"

    invite = mock_test_invite({:friends => crazy_but_valid_friendly_name})
    assert invite.is_valid?
  end

  test "A few characters are not valid Friendly formatted email" do
    invalid_friendly_names = '[]\\`"| <pathologicallyinvalid@case.net>, seps,;are <invalid@chars.org>'
    # puts "Pathological invalid cases: #{invalid_friendly_names}"

    invite = mock_test_invite({:friends => invalid_friendly_names})
    # invite.emails.each{|e| puts "Parsed email: \"#{e}\""}
    # invite.errors.each{|e| puts "Parsed error: \"#{e}\""}
    assert !invite.is_valid?
    assert_equal 3, invite.emails.size
    assert_equal 2, invite.errors.size # last one parsed as "are <invalid@chars.org>", which is valid
  end
  
  test "Will not accept invalid email formats" do
    invite = mock_test_invite({:friends => "thisis@bad, this@ok.com, invalid@topleveldomain, invalid@topleveldomain.12345, missing langle friendly@err.org>, missing rangle <friendly@err.org"})
    assert !invite.is_valid?
    assert_equal 6, invite.emails.size
    assert_equal 5, invite.errors.size
  end
  
  test "Can accept emails delimited by comma" do
    do_test_of_delimited_email(", ", mock_email_distro)
  end
  
  test "Can accept emails delimited by semi-colon" do
    do_test_of_delimited_email("; ", mock_email_distro)
  end
  
  test "Can accept emails delimited by carriage return" do
    do_test_of_delimited_email("\r", mock_email_distro)
  end
  
  test "Can accept emails delimited by new-line" do
    do_test_of_delimited_email("\r", mock_email_distro)
  end
  
  test "Can accept emails delimited by CRLF" do
    do_test_of_delimited_email("\r\n", mock_email_distro)
  end
  
  test "Can accept delimited emails padded with whitespace" do
    do_test_of_delimited_email("\t;  ", mock_email_distro)
  end
  
  test "Can handle empty email list" do
    invite = mock_test_invite({:friends => nil})
    assert !invite.is_valid?
  end
  
  test "Will remove any duplicate emails from the friends list" do
    invite = mock_test_invite({:friends => "a@b.com; b@c.com; a@b.com; c@d.com;  a@b.com; e@f.com"})    
    assert invite.is_valid?
    assert_equal 4, invite.emails.size
  end
  
  test "Invitation list defaults to 10 invitees" do
    invite = mock_test_invite({:friends => mock_variable_email_distro(10)})
    assert invite.is_valid?
    
    invite = mock_test_invite({:friends => mock_variable_email_distro(11)})
    assert !invite.is_valid?
  end
  
  test "Invitation list limit can be specified" do
    invite = mock_test_invite({:friends => mock_variable_email_distro(5), :limit => 5})
    assert invite.is_valid?
    
    invite = mock_test_invite({:friends => mock_variable_email_distro(6), :limit => 5})
    assert !invite.is_valid?
  end
  
protected

  def mock_test_invite(options = {})
    Invitation.new({
      :title => "This is a test",
      :message => "Check it out",
      :friends => mock_email_distro.join(", ")
      }.merge(options))
  end
  
  def mock_email_distro
    ["a@b.com", "c@d.com", "foo@bar.net"]
  end
  
  def mock_variable_email_distro(count)
    (1..count).inject([]){|distro, i| distro << "foo+#{i}@bar.com"}.join(", ")
  end
  
  def do_test_of_delimited_email(list_sep, distro)
    emails = distro
    invite = mock_test_invite({:friends => mock_email_distro.join(list_sep)})
    # puts "Friends' emails: \"#{invite.emails.join("\" \"")}\""
    # invite.errors.each {|err| puts "Error: #{err}"} unless invite.is_valid?
    
    assert_tag = "[Delimit test, list_sep=\"#{list_sep}\"]"
    assert invite.is_valid?, "#{assert_tag} Invitation is not valid"
    
    assert_equal emails.size, invite.emails.size, "#{assert_tag} Number of emails invite doesn't match input"
    invite.emails.each {|email| assert_not_nil emails.include?(email), "#{assert_tag} #{email} not included in invite"}
  end
  
end
