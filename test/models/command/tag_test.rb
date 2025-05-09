require "test_helper"

class Command::TagTest < ActionDispatch::IntegrationTest
  include CommandTestHelper

  setup do
    Current.session = sessions(:david)
    @card = cards(:text)
    @tag = tags(:web)
  end

  test "tag card on perma with existing tag" do
    assert_changes -> { @card.tagged_with?(@tag) }, from: false, to: true do
      execute_command "/tag #{@tag.title}", context_url: collection_card_url(@card.collection, @card)
    end
  end

  test "tag card on perma with new tag" do
    assert_difference -> { @card.tags.count }, +1 do
      execute_command "/tag some-new-tag", context_url: collection_card_url(@card.collection, @card)
    end

    assert_equal "some-new-tag", @card.tags.last.title
  end

  test "tag several cards on cards' index page" do
    cards = cards(:logo, :text, :layout)
    cards.each { it.taggings.destroy_all }

    execute_command "/tag #{@tag.title}", context_url: collection_cards_url(@card.collection)

    cards.each { assert it.reload.tagged_with?(@tag) }
  end

  test "undo tagged cards" do
    cards = cards(:logo, :text, :layout)
    cards.each { it.taggings.destroy_all }

    command = parse_command "/tag #{@tag.title}", context_url: collection_cards_url(@card.collection)
    command.execute

    cards.each { assert it.reload.tagged_with?(@tag) }

    command.undo
    cards.each { assert_not it.reload.tagged_with?(@tag) }
  end
end
