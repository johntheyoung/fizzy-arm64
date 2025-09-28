require "test_helper"

class Collection::TriageableTest < ActiveSupport::TestCase
  test "creating collection creates default columns" do
    assert_difference -> { Column.count }, Collection::Triageable::DEFAULT_COLUMNS.size do
      collection = Collection.create! name: "Test Collection", creator: users(:david)

      assert_equal Collection::Triageable::DEFAULT_COLUMNS.size, collection.columns.count

      Collection::Triageable::DEFAULT_COLUMNS.each_with_index do |default_column, index|
        column = collection.columns.order(:id)[index]
        assert_equal default_column[:name], column.name
        assert_equal default_column[:color], column.color
      end
    end
  end
end
