module Command::Tags
  extend ActiveSupport::Concern

  included do
    store_accessor :data, :tag_title

    validates_presence_of :tag_title
  end

  private
    def tag
      Tag.find_or_create_by!(title: tag_title)
    end
end
