require File.dirname(__FILE__) + '/../test_helper'

class FriendNotifierTest < ActiveSupport::TestCase
  def setup
    @donor = Donor.new({:first_name => "Newt",
    :last_name => "Donor",
    :login => "foo@bar.com",
    :login_confirmation => "foo@bar.com",
    :password => "foo2thebar",
    :password_confirmation => "foo2thebar",
    :birthday => 21.years.ago
    })
    @donor.save!
    
    title   = "Yo' yo' Holmes! You be donatin'!"
    message = "Hi! I wanted to let you know about a great new website called SaveTogether (http://www.savetogether.org).      \
              It allows each of us to participate in helping working Americans achieve their dreams by matching their savings \
              goals so they can make life-changing investments in a college education, small business, or a first home.       \
              Check it out and donate to join someone on the path to financial opportunity.   It’s fun – I did it!".gsub(/[ ]+/, " ")
    friends = "fred@foo.com barry@bar.net inga@bazinga.org"
    
    @invite = Invitation.new({:title => title, :message => message, :friends => friends})
  end
  
  test "Invitation email is templated" do
    invitation_email = UserNotifier.create_friends_invitation(@invite, @donor)
    
    assert_match /#{@invite.title}/, invitation_email.subject
    @invite.emails.each{|email| assert invitation_email.to.include?(email)}
    assert_match /SaveTogether member #{@donor.first_name} #{@donor.last_name}/, invitation_email.body
    assert_match /#{Regexp.escape(@invite.message)}/, invitation_email.body
  end
  
end
