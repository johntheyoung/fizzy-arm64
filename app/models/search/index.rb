class Search::Index < ApplicationRecord
  self.table_name = "search_index_0"

  # Dynamically target the correct sharded table based on account_id
  def self.for_account(account_id)
    from(Searchable.search_index_table_name(account_id))
  end

  # Scope for fulltext search
  def self.matching(query_string)
    where("MATCH(content, title) AGAINST(? IN BOOLEAN MODE)", query_string)
  end

  # Scope for filtering by board IDs with proper UUID serialization
  def self.in_boards(board_ids)
    # Use string interpolation to avoid table aliasing issues with .from()
    where("board_id IN (?)", serialize_uuids(board_ids))
  end

  # Associations
  belongs_to :card, optional: false
  belongs_to :board, optional: false

  # Polymorphic searchable (Card or Comment)
  def searchable
    searchable_type.constantize.find(searchable_id)
  end

  def card?
    searchable_type == "Card"
  end

  def comment?
    searchable_type == "Comment"
  end

  # Class methods for UUID handling
  def self.serialize_uuid(value)
    Search.serialize_uuid(value)
  end

  def self.serialize_uuids(values)
    Search.serialize_uuids(values)
  end

  # Insert/Update/Delete with proper UUID serialization
  def self.create_index_entry(account_id:, searchable_type:, searchable_id:, card_id:, board_id:, title:, content:, created_at:)
    connection.execute sanitize_sql([
      "INSERT INTO #{Searchable.search_index_table_name(account_id)} (id, searchable_type, searchable_id, card_id, board_id, title, content, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
      serialize_uuid(ActiveRecord::Type::Uuid.generate),
      searchable_type,
      serialize_uuid(searchable_id),
      serialize_uuid(card_id),
      serialize_uuid(board_id),
      title,
      content,
      created_at
    ])
  end

  def self.update_index_entry(account_id:, searchable_type:, searchable_id:, card_id:, board_id:, title:, content:, created_at:)
    result = connection.execute sanitize_sql([
      "UPDATE #{Searchable.search_index_table_name(account_id)} SET card_id = ?, board_id = ?, title = ?, content = ?, created_at = ? WHERE searchable_type = ? AND searchable_id = ?",
      serialize_uuid(card_id),
      serialize_uuid(board_id),
      title,
      content,
      created_at,
      searchable_type,
      serialize_uuid(searchable_id)
    ])

    if result.affected_rows == 0
      create_index_entry(
        account_id: account_id,
        searchable_type: searchable_type,
        searchable_id: searchable_id,
        card_id: card_id,
        board_id: board_id,
        title: title,
        content: content,
        created_at: created_at
      )
    end
  end

  def self.delete_index_entry(account_id:, searchable_type:, searchable_id:)
    connection.execute sanitize_sql([
      "DELETE FROM #{Searchable.search_index_table_name(account_id)} WHERE searchable_type = ? AND searchable_id = ?",
      searchable_type,
      serialize_uuid(searchable_id)
    ])
  end
end
