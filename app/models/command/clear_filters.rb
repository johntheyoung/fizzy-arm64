class Command::ClearFilters < Command
  store_accessor :data, :params

  def title
    "Clear filters"
  end

  def execute
    redirect_to cards_path(**params.to_h.with_indifferent_access.without(*filters_to_clear))
  end

  private
    FILTERS_TO_KEEP = [ :collection_ids, :indexed_by ]

    def filters_to_clear
      Filter::Params::PERMITTED_PARAMS
        .flat_map { |param| param.is_a?(Hash) ? param.keys : param }
        .without(*FILTERS_TO_KEEP)
    end
end
