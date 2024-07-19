require "test_helper"

class VoluntaryInsurancesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get voluntary_insurances_new_url
    assert_response :success
  end

  test "should get create" do
    get voluntary_insurances_create_url
    assert_response :success
  end

  test "should get edit" do
    get voluntary_insurances_edit_url
    assert_response :success
  end

  test "should get update" do
    get voluntary_insurances_update_url
    assert_response :success
  end
end
