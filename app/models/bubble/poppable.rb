module Bubble::Poppable
  extend ActiveSupport::Concern

  included do
    has_one :pop, dependent: :destroy

    scope :popped, -> { joins(:pop) }
    scope :not_popped, -> { where.missing(:pop) }
  end

  def popped?
    pop.present?
  end

  def pop!(user: Current.user)
    create_pop!(user: user) unless popped?
  end

  def unpop
    pop&.destroy
  end
end
