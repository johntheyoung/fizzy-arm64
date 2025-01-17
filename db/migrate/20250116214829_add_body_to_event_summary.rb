class AddBodyToEventSummary < ActiveRecord::Migration[8.1]
  def change
    add_column :event_summaries, :body, :string, null: true
    EventSummary.find_each(&:reset_body)
    change_column_null :event_summaries, :body, false
  end
end
