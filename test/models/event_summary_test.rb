require "test_helper"

class EventSummaryTest < ActiveSupport::TestCase
  test "body" do
    event_summaries(:logo_initial_activity).update! body: "foo"
    event_summaries(:logo_initial_activity).reset_body

    publication_time = %Q(<time datetime="#{events(:logo_published).created_at.iso8601}" data-local-time-target="ago" data-delimiter="."></time>)
    assignment_time = %Q(<time datetime="#{events(:logo_assignment_jz).created_at.iso8601}" data-local-time-target="ago" data-delimiter="."></time>)
    assert_equal %Q(Added by David #{publication_time} Assigned to JZ #{assignment_time} David +1.), event_summaries(:logo_initial_activity).body
  end
end
