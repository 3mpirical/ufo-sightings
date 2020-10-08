require 'test_helper'

class Api::TestsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_tests_show_url
    assert_response :success
  end

end
