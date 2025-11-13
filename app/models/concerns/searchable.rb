module Searchable
  extend ActiveSupport::Concern

  SHARD_COUNT = 16

  def self.search_index_table_name(account_id)
    "search_index_#{Zlib.crc32(account_id) % SHARD_COUNT}"
  end

  included do
    after_create_commit :create_in_search_index
    after_update_commit :update_in_search_index
    after_destroy_commit :remove_from_search_index
  end

  def reindex
    update_in_search_index
  end

  private
    def create_in_search_index
      Search::Index.create_index_entry(
        account_id: account_id,
        searchable_type: self.class.name,
        searchable_id: id,
        card_id: search_card_id,
        board_id: search_board_id,
        title: search_title,
        content: search_content,
        created_at: created_at
      )
    end

    def update_in_search_index
      Search::Index.update_index_entry(
        account_id: account_id,
        searchable_type: self.class.name,
        searchable_id: id,
        card_id: search_card_id,
        board_id: search_board_id,
        title: search_title,
        content: search_content,
        created_at: created_at
      )
    end

    def remove_from_search_index
      Search::Index.delete_index_entry(
        account_id: account_id,
        searchable_type: self.class.name,
        searchable_id: id
      )
    end

    # Models must implement these methods:
    # - search_title: returns title string or nil
    # - search_content: returns content string
    # - search_card_id: returns the card id (self.id for cards, card_id for comments)
    # - search_board_id: returns the board id
end
