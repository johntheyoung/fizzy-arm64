module Bucket::View::Assignees
  private
    def assignee_names
      assignees.map &:name
    end

    def assignees
      @assignees ||= account.users.where id: assignee_ids
    end
end
