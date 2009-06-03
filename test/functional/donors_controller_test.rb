require 'test_helper'

class DonorsControllerTest < ActionController::TestCase
  
  test "A new donor request results in an empty donor template" do
    get :new
    assert_template 'new'
    assert_response :success
  end
  
  test "Successful donor creation redirects to Signup Completed flow" do
    assert_difference 'Donor.count', +1 do
      post :create, :donor => min_donor_props
    end
    assert_redirected_to :controller => :users, :action => :signup_completed, :id => min_donor_props[:login]
    assert_equal flash[:notice], :email_signup_thanks.l_with_args(:email => min_donor_props[:email])
  end
  
  test "Unsuccessful donor creation re-renders the new template" do
    assert_no_difference 'Donor.count' do
      post :create, :donor => min_donor_props(:login => nil)
    end
    assert_template 'new'
    assert_response :success
  end

  protected
  
  def min_donor_props(options = {})
    {
      
      :login => "a@b.com",
      :login_confirmation => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago
      
    }.merge(options)
    
  end

end
