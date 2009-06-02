require 'test_helper'

class DonorsControllerTest < ActionController::TestCase
  
  def setup
    @good_donor_properties = {
      :login => "foobar",
      :email => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago
      }
    @bad_donor_properties = @good_donor_properties.dup
    @bad_donor_properties.delete(:login)
  end
  
  test "(sanity) good donor properties are good" do
    donor = Donor.new(@good_donor_properties)
    isValid = donor.valid?
    donor.errors.each {|e, m| puts "Error: #{e} #{m}"}
    assert isValid
  end
  
  test "(sanity) bad donor properties are bad" do
    donor = Donor.new(@bad_donor_properties)
    assert !donor.valid?
  end
  
  test "A new donor request results in an empty donor template" do
    get :new
    assert_template 'new'
    assert_response :success
  end
  
  test "Successful donor creation redirects to Signup Completed flow" do
    assert_difference 'Donor.count', +1 do
      post :create, :donor => @good_donor_properties
    end
    assert_redirected_to :controller => :users, :action => :signup_completed, :id => @good_donor_properties[:login]
    assert_equal flash[:notice], :email_signup_thanks.l_with_args(:email => @good_donor_properties[:email])
  end
  
  test "Unsuccessful donor creation re-renders the new template" do
    assert_no_difference 'Donor.count' do
      post :create, :donor => @bad_donor_properties
    end
    assert_template 'new'
    assert_response :success
  end

end
