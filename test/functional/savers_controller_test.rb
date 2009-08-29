require 'test_helper'

class SaversControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  test "update a saver profile" do
    saver = users(:saver)
    login_as(:saver)

    cents1 = saver.requested_match_cents

    post :update, {:id => saver.id,
                   :saver =>
                     {:requested_match => (cents1 + 1000).to_s,
                      :asset_type_id => saver.asset_type_id.to_s}}

    assert_redirected_to saver_path(saver)
    saver2 = Saver.find(saver.id)
    cents2 = saver2.requested_match_cents
    assert cents2 != cents1
  end

  test "updating user not logged in" do
    saver = users(:saver)

    cents1 = saver.requested_match_cents

    post :update, {:id => saver.id,
                   :saver =>
                     {:requested_match => (cents1 + 1000).to_s,
                      :asset_type_id => saver.asset_type_id.to_s}}

    assert_redirected_to saver_path(saver)
    saver2 = Saver.find(saver.id)
    cents2 = saver2.requested_match_cents
    assert cents2 == cents1
  end

  test "editing user that isnt logged in" do
    saver = users(:saver)

    get :edit, {:id => saver.id}

    assert_redirected_to saver_path(saver)
  end

  test "assert editing a saver that is logged in works" do
    saver = users(:saver)
    login_as (:saver)

    get :edit, {:id => saver.id}

    assert_response :success  
  end

  test "get index with no parameters" do
    get :index

    assert session[:order_by] == 'first_name'
    assert session[:order] == 'ASC'
  end

  test "find savers by organization_id" do
    org = users(:earn)
    get :index, {:organization_id => org.id}

    assert_response :success
    savers = @response.template.assigns['savers']
    assert savers.size > 0

    savers.each do |saver|
      assert saver.organization.first_name == org.first_name
    end
  end

  test "sort savers by asset_type" do
    get :index, {:order_by => 'asset_types.asset_name'}

    assert session[:order_by] == 'asset_types.asset_name'
    assert session[:order] == 'ASC'
  end

  test "sort savers by metro_area" do
    get :index, {:order_by => 'metro_areas.name'}

    assert session[:order_by] == 'metro_areas.name'
    assert session[:order] == 'ASC'
  end

  test "sort savers by metro_area in descending order" do
    session[:order_by] = 'metro_areas.name'
    session[:order] = 'ASC'

    get :index, {:order_by => 'metro_areas.name'}

    assert session[:order_by] == 'metro_areas.name'
    assert session[:order] == 'DESC'
  end
end