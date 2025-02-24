module Bubble::Watchable extend ActiveSupport::Concern
  included do
    has_many :watches, dependent: :destroy
    has_many :watchers, through: :watches, source: :user

    after_create :create_initial_watches
  end

  private
    def create_initial_watches
      Watch.insert_all(bucket.users.pluck(:id).collect { |user_id| { user_id: user_id, bubble_id: id } })
    end
end
