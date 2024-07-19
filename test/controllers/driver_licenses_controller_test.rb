require "test_helper"

class DriverLicensesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get driver_licenses_new_url
    assert_response :success
  end

  test "should get create" do
    get driver_licenses_create_url
    assert_response :success
  end

  test "should get edit" do
    get driver_licenses_edit_url
    assert_response :success
  end

  test "should get update" do
    get driver_licenses_update_url
    assert_response :success
  end
end
