require "test_helper"

class Collections::ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "show" do
    get collection_column_path(collections(:writebook), columns(:writebook_in_progress))
    assert_response :success
  end

  test "create" do
    assert_difference -> { collections(:writebook).columns.count }, +1 do
      post collection_columns_path(collections(:writebook)), params: { column: { name: "New Column" } }, as: :turbo_stream
      assert_response :success
    end

    assert_equal "New Column", collections(:writebook).columns.last.name
  end

  test "update" do
    column = columns(:writebook_in_progress)

    assert_changes -> { column.reload.name }, from: "In progress", to: "Updated Name" do
      put collection_column_path(collections(:writebook), column), params: { column: { name: "Updated Name" } }, as: :turbo_stream
      assert_response :success
    end
  end

  test "destroy" do
    column = columns(:writebook_on_hold)

    assert_difference -> { collections(:writebook).columns.count }, -1 do
      delete collection_column_path(collections(:writebook), column), as: :turbo_stream
      assert_response :success
    end
  end
end
