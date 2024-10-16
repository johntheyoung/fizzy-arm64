class Bucket::View < ApplicationRecord
  FILTERS = [ :assignee_ids, :order_by, :status, :tag_ids ]

  include Summarized, Assignees, Tags

  belongs_to :creator, class_name: "User", default: -> { Current.user }
  belongs_to :bucket

  has_one :account, through: :creator

  store_accessor :filters, *FILTERS

  validate :must_have_filters, :must_not_be_the_default_view

  def to_bucket_params
    filters.compact_blank
  end

  private
    ORDERS = {
      "most_active" => "most active",
      "most_discussed" => "most discussed",
      "most_boosted" => "most boosted",
      "newest" => "newest",
      "oldest" => "oldest" }
    STATUSES = {
      "unassigned" => "unassigned",
      "popped" => "popped" }

    def must_have_filters
      errors.add(:base, "must have filters") if filters.values.all?(&:blank?)
    end

    def must_not_be_the_default_view
      errors.add(:base, "must be different than the default view") if filters.compact_blank == { "order_by" => "most_active" }
    end
end
