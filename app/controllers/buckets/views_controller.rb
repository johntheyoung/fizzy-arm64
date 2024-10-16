class Buckets::ViewsController < ApplicationController
  include BucketScoped

  def create
    @bucket.views.create! filters: view_params.merge(assignee_ids:, tag_ids:).compact_blank
    redirect_back_or_to bucket_bubbles_path(@bucket), notice: "Filters saved"
  end

  private
    def view_params
      params.require(:view).permit(:order_by, :status, :assignee_ids, :tag_ids)
    end

    def assignee_ids
      view_params[:assignee_ids]&.split(",")
    end

    def tag_ids
      view_params[:tag_ids]&.split(",")
    end
end
