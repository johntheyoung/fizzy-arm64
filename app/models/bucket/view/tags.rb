module Bucket::View::Tags
  private
    def tag_names
      tags.map &:hashtag
    end

    def tags
      @tags ||= account.tags.where id: tag_ids
    end
end
