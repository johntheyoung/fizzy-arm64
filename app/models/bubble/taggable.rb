module Bubble::Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, ->(tags) { joins(:taggings).where(taggings: { tag: tags }) }
  end
end
