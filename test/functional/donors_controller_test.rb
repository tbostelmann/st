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
    donor = Donor.find_by_login(min_donor_props[:login])
    assert_redirected_to :controller => :users, :action => :signup_completed, :id => donor.id
    assert_equal flash[:notice], :email_signup_thanks.l_with_args(:email => donor.email)
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
      :first_name => "Min",
      :last_name => "Donor",
      :login_confirmation => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar",
      :birthday => 21.years.ago
      
    }.merge(options)
    
  end

end
