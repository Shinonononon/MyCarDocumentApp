require "test_helper"

class CompulsoryInsurancesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get compulsory_insurances_new_url
    assert_response :success
  end

  test "should get create" do
    get compulsory_insurances_create_url
    assert_response :success
  end

  test "should get edit" do
    get compulsory_insurances_edit_url
    assert_response :success
  end

  test "should get update" do
    get compulsory_insurances_update_url
    assert_response :success
  end
end
