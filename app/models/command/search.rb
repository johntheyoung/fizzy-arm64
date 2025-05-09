class Command::Search < Command
  store_accessor :data, :query, :params

  def title
    "Search '#{query}'"
  end

  def execute
    redirect_to cards_path(**params.without("terms").merge(terms: Array.wrap(query.presence)))
  end
end
