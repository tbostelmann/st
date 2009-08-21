require 'test_helper'

class SaversControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

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