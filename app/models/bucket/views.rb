module Bucket::Views
  extend ActiveSupport::Concern

  included do
    has_many :views, dependent: :delete_all
  end
end
