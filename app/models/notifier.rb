class Notifier
  attr_reader :event

  delegate :creator, to: :event

  class << self
    def for(event)
      "Notifier::#{event.action.classify}".safe_constantize&.new(event)
    end
  end

  def generate
    if should_notify?
      recipients.map do |recipient|
        Notification.create! user: recipient, event: event, bubble: bubble, resource: resource
      end
    end
  end

  private
    def initialize(event)
      @event = event
    end

    def should_notify?
      !event.creator.system?
    end

    def recipients
      bubble.watchers.without(creator)
    end

    def resource
      bubble
    end

    def bubble
      event.summary.message.bubble
    end
end
