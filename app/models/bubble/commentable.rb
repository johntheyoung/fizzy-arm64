module Bubble::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy

    scope :ordered_by_comments, -> { left_joins(:comments).group(:id).order("COUNT(comments.id) DESC") }
  end

  def comment!(body)
    comments.create! body:
  end
end
