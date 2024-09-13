class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :bubbles, through: :taggings
end
