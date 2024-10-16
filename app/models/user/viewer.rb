module User::Viewer
  extend ActiveSupport::Concern

  included do
    has_many :bucket_views, class_name: "Bucket::View", foreign_key: :creator_id, dependent: :destroy
  end
end
