class Command::Tag < Command
  include Command::Cards, Command::Tags

  store_accessor :data, :tagged_card_ids

  def title
    "Tag #{cards_description} with ##{tag_title}"
  end

  def execute
    tagged_card_ids = []

    transaction do
      cards.find_each do |card|
        unless card.tagged_with?(tag)
          tagged_card_ids << card.id
          card.toggle_tag_with(tag_title)
        end
      end

      update! tagged_card_ids: tagged_card_ids
    end
  end

  def undo
    transaction do
      tagged_cards.find_each do |card|
        card.toggle_tag_with(tag_title) if card.tagged_with?(tag)
      end
    end
  end

  private
    def tagged_cards
      user.accessible_cards.where(id: tagged_card_ids)
    end
end
