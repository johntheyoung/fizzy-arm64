module Bubble::Assignable
  extend ActiveSupport::Concern

  included do
    has_many :assignments, dependent: :delete_all

    has_many :assignees, through: :assignments
    has_many :assigners, through: :assignments

    scope :unassigned, -> { where.missing :assignments }
    scope :assigned_to, ->(users) { joins(:assignments).where(assignments: { assignee: users }) }
  end

  def assign(users, assigner: Current.user)
    transaction do
      Assignment.insert_all assignee_rows_from(users)
      track_event :assigned, assignee_ids: Array(users).map(&:id)
    end
  end

  private
    def assignee_rows_from(users)
      Array(users).collect { |user| { assignee_id: user.id, assigner_id: assigner.id, bubble_id: id } }
    end
end
