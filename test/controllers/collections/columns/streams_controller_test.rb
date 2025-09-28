require "test_helper"

class Collections::Columns::StreamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "show" do
    get collection_columns_stream_path(collections(:writebook))
    assert_response :success
  end
end
