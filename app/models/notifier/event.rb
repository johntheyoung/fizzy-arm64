class Notifier::Event < Notifier
  delegate :card, :creator, to: :source
  delegate :watchers_and_subscribers, to: :card

  private
    def recipients
      case source.action
      when "assigned"
        source.assignees.excluding(card.collection.access_only_users)
      when "published"
        watchers_and_subscribers(include_only_watching: true).without(creator, *card.mentionees)
      when "commented"
        watchers_and_subscribers.without(creator, *source.comment.mentionees)
      else
        watchers_and_subscribers.without(creator)
      end
    end
end
