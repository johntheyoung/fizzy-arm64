require "test_helper"

class Command::FilterTest < ActionDispatch::IntegrationTest
  include CommandTestHelper

  setup do
    Current.session = sessions(:david)
  end

  test "clear the filters keeping the selected collections" do
    result = execute_command "/clear", context_url: "?card_ids%5B%5D=1&card_ids%5B%5D=2&collection_ids%5B%5D=#{collections(:writebook).id}&indexed_by=newest&terms%5B%5D=jorge"

    assert_equal cards_path(indexed_by: "newest", collection_ids: [ collections(:writebook).id ]), result.url
  end
end
