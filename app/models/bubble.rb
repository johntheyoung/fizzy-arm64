class Bubble < ApplicationRecord
  include ::Searchable
  include Assignable, Boostable, Colored, Commentable, Eventable, Poppable, Searchable, Taggable, Threaded

  belongs_to :bucket
  belongs_to :creator, class_name: "User", default: -> { Current.user }

  has_one_attached :image, dependent: :purge_later

  searchable_by :title, using: :bubbles_search_index

  before_save :set_default_title

  scope :reverse_chronologically, -> { order created_at: :desc, id: :desc }
  scope :chronologically, -> { order created_at: :asc, id: :asc }
  scope :ordered_by_activity, -> { left_joins(:comments).group(:id).order(Arel.sql("COUNT(comments.id) + boost_count DESC")) }
  scope :with_status, ->(status) { public_send status.presence_in(%w[ popped not_popped unassigned ]) }
  scope :ordered_by, ->(order) do
    case order
    when "most_active"    then ordered_by_activity
    when "most_discussed" then ordered_by_comments
    when "most_boosted"   then ordered_by_boosts
    when "newest"         then reverse_chronologically
    when "oldest"         then chronologically
    end
  end

  class << self
    def default_order_by
      "most_active"
    end

    def default_status
      "not_popped"
    end
  end

  private
    def set_default_title
      self.title = title.presence || "Untitled"
    end
end
