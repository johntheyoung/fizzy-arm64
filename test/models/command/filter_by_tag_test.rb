require "test_helper"

class Command::FilterByCardTest < ActionDispatch::IntegrationTest
  include CommandTestHelper

  setup do
    @tag = tags(:web)
  end

  test "redirect to the cards index filtering by cards" do
    result = execute_command "##{@tag.title}"

    assert_equal cards_path(indexed_by: "newest", tag_ids: [ @tag.id ]), result.url
  end
end
