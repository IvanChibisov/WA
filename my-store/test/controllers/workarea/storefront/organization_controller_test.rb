require 'test_helper'

class Workarea::Storefront::OrganizationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get workarea_storefront_organization_index_url
    assert_response :success
  end

end
