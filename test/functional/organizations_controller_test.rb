require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "show an organization" do
    org = users(:earn)
    get :show, {:id => org.id}
    assert_response :success
    assert_template :show

    storg = users(:savetogether)
    get :show, {:id => storg.id}
    assert_response :success
    assert_template :show
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
end
