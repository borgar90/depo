require "test_helper"

class ReturnOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get return_order_show_url
    assert_response :success
  end

  test "should get edit" do
    get return_order_edit_url
    assert_response :success
  end

  test "should get update" do
    get return_order_update_url
    assert_response :success
  end
end
