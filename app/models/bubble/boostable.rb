module Bubble::Boostable
  extend ActiveSupport::Concern

  included do
    scope :ordered_by_boosts, -> { order boost_count: :desc }
  end

  def boost!
    transaction do
      increment! :boost_count
      track_event :boosted
    end
  end
end
