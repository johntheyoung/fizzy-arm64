module Event::Assignments
  extend ActiveSupport::Concern

  included do
    store_accessor :particulars, :assignee_ids
  end

  def assignee_names
    assignees.map &:name
  end

  private
    def assignees
      @assignees ||= account.users.where id: assignee_ids
    end
end
