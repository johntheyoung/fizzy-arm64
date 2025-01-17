class EventSummary < ApplicationRecord
  include Messageable

  has_many :events, -> { chronologically }, dependent: :delete_all, inverse_of: :summary

  before_create { self.body = generate_body }

  def reset_body
    update! body: generate_body
  end

  private
    delegate :local_datetime_tag, to: "ApplicationController.helpers", private: true

    def generate_body
      "#{main_summary} #{boosts_summary}".squish
    end

    def main_summary
      events.non_boosts.map { |event| summarize(event) }.join(" ")
    end

    def summarize(event)
      case event.action
      when "published"
        "Added by #{event.creator.name} #{local_datetime_tag(event.created_at, style: :ago, delimiter: ".")}"
      when "assigned"
        "Assigned to #{event.assignees.pluck(:name).to_sentence} #{local_datetime_tag(event.created_at, style: :ago, delimiter: ".")}"
      when "unassigned"
        "Unassigned from #{event.assignees.pluck(:name).to_sentence} #{local_datetime_tag(event.created_at, style: :ago, delimiter: ".")}"
      when "staged"
        "#{event.creator.name} moved this to '#{event.stage_name}'."
      when "unstaged"
        "#{event.creator.name} removed this from '#{event.stage_name}'."
      end
    end

    def boosts_summary
      if tally = events.boosts.group(:creator).count.presence
        tally.map do |creator, count|
          "#{creator.name} +#{count}"
        end.to_sentence + "."
      end
    end
end
