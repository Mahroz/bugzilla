require 'test_helper'

class ErrorControllerTest < ActionDispatch::IntegrationTest
  test "should get notFound" do
    get error_notFound_url
    assert_response :success
  end

end
