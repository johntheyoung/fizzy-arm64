module Card::Searchable
  extend ActiveSupport::Concern

  included do
    include ::Searchable

    scope :mentioning, ->(query, user:) do
      query = Search::Query.wrap(query)

      if query.valid?
        index_scope = Search::Index
          .for_account(user.account_id)
          .in_boards(user.board_ids)
          .matching(query.to_s)
          .select(:card_id)

        where(id: index_scope)
          .distinct
      else
        none
      end
    end
  end

  private
    def search_title
      Search::Stemmer.stem title
    end

    def search_content
      Search::Stemmer.stem description.to_plain_text
    end

    def search_card_id
      id
    end

    def search_board_id
      board_id
    end
end
