require "test_helper"

class VehicleInspectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get vehicle_inspections_new_url
    assert_response :success
  end

  test "should get create" do
    get vehicle_inspections_create_url
    assert_response :success
  end

  test "should get edit" do
    get vehicle_inspections_edit_url
    assert_response :success
  end

  test "should get update" do
    get vehicle_inspections_update_url
    assert_response :success
  end
end
