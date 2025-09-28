require "test_helper"

class Collections::Columns::NotNowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "show" do
    get collection_columns_not_now_path(collections(:writebook))
    assert_response :success
  end
end
