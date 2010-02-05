require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    # allows you to inspect email notifications
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  test "create organization" do
    post :create, :organization => min_organization_props(:organization_survey_attributes => {:location_state => "WA", :location_city => "Seattle"})

    assert_response :success
    assert_template :show
    org = assigns['org']
    assert_not_nil org
    assert org.errors.size == 0
    assert_not_nil session[:user]
    assert !org.profile_public
    assert_equal 1, @emails.size
    assert_equal "[SaveTogether] Your SaveTogether account has been activated!", @emails[0].subject
    org = assigns['org']
    assert_equal org.login, @emails[0].to[0]
    assert_match /Dear #{org.first_name},/, @emails[0].body
  end

  test "create invalid organization should show correct error" do
    post :create, :organization => min_organization_props(:login_confirmation => 'invalid@foo.com',
                                                          :organization_survey_attributes => {:location_state => "WA",
                                                                                   :location_city => "Seattle"})

    assert_response :success
    assert_template :new
    org = assigns['org']
    assert_not_nil org
    assert org.errors.size > 0
  end

  test "get new organization page" do
    get :new

    assert_response :success
  end

  test "get organization index page" do
    get :index

    assert_response :success
  end

  test "show an organization with no organization_survey contents" do
    org = users(:cfed)
    assert !org.has_organization_survey?

    get :show, {:id => org.id}

    assert_response :success
    assert_template :show
  end

  test "show an organization that is not public" do
    storg = users(:savetogether)
    get :show, {:id => storg.id}
    assert_redirected_to home_path
  end

  test "show an organization" do
    org = users(:earn)
    get :show, {:id => org.id}
    assert_response :success
    assert_template :show
  end

  test "edit an organization" do
    org = users(:earn)
    login_as(:earn)

    get :edit, {:id => org.id}
    assert_response :success
    assert_template :edit
  end

  test "edit an organization that is not logged in" do
    org = users(:earn)

    get :edit, {:id => org.id}
    assert_redirected_to login_path
  end

  test "edit an organization when logged in as a different user" do
    donor = users(:donor)
    org = users(:earn)
    login_as(:donor)
    get :edit, {:id => org.id}
    assert_redirected_to :controller => :organizations, :action => :show
  end

  test "update an organization profile" do
    org = users(:earn)
    login_as(:earn)

    old_ce = org.organization_survey.contact_email.to_s

    post :update, {:organization =>
            {:phone_number => org.phone_number.to_s,
             :web_site_url => org.web_site_url.to_s,
             :organization_survey_attributes =>
                     {:id => org.organization_survey.id.to_s,
                      :year_founded => org.organization_survey.year_founded.to_s,
                      :contact_email => "foo@savetogether.org",
                      :annual_operating_expenses => org.organization_survey.annual_operating_expenses.to_s,
                      :total_matched_accounts => org.organization_survey.total_matched_accounts.to_s,
                      :year_first_accounts_opened => org.organization_survey.year_first_accounts_opened.to_s,
                      :number_of_active_accounts => org.organization_survey.number_of_active_accounts.to_s}}}

    assert_response :success
    org2 = Organization.find(org.id)
    new_ce = org2.organization_survey.contact_email.to_s
    assert old_ce == new_ce
  end

  protected

  def min_organization_props(options = {})
    {

      :login => "a@b.com",
      :first_name => "Min",
      :login_confirmation => "a@b.com",
      :password => "foo2thebar",
      :password_confirmation => "foo2thebar"
    }.merge(options)

  end
end
