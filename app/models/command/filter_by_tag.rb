class Command::FilterByTag < Command
  include Command::Tags

  store_accessor :data, :params

  def title
    "Filter by tag ##{tag_title}"
  end

  def execute
    redirect_to cards_path(**params.merge(tag_ids: [ tag.id ]))
  end
end
