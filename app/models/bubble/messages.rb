module Bubble::Messages
  extend ActiveSupport::Concern

  included do
    has_many :messages, -> { chronologically }, dependent: :destroy
  end

  def capture(messageable)
    messages.create! messageable: messageable
  end

  def reflow_messages
    messages.chronologically.each_cons(2) do |previous, current|
      if current.event_summary? && previous.event_summary?
        current.event_summary.events.update_all(summary_id: previous.event_summary.id)
        previous.event_summary.reset_body
        current.destroy!
      end
    end
  end
end
