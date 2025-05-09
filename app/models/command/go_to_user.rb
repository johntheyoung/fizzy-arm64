class Command::GoToUser < Command
  store_accessor :data, :user_id

  validates_presence_of :user

  def title
    "View profile of '#{user.name}'"
  end

  def execute
    redirect_to user
  end

  private
    def user
      User.find_by_id(user_id)
    end
end
