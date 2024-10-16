class BubblesController < ApplicationController
  include BucketScoped

  before_action :set_bubble, only: %i[ show edit update ]
  before_action :set_assignee_filters, :set_tag_filters, only: :index

  def index
    @bubbles = @bucket.bubbles
    @bubbles = @bubbles.ordered_by(params[:order_by] || Bubble.default_order_by)
    @bubbles = @bubbles.with_status(params[:status] || Bubble.default_status)
    @bubbles = @bubbles.tagged_with(@tag_filters) if @tag_filters
    @bubbles = @bubbles.assigned_to(@assignee_filters) if @assignee_filters
    @bubbles = @bubbles.mentioning(params[:term]) if params[:term]
  end

  def new
    @bubble = @bucket.bubbles.build
  end

  def create
    @bubble = @bucket.bubbles.create!
    redirect_to bucket_bubble_url(@bucket, @bubble)
  end

  def show
  end

  def edit
  end

  def update
    @bubble.update! bubble_params
    redirect_to bucket_bubble_url(@bucket, @bubble)
  end

  private
    def set_bubble
      @bubble = @bucket.bubbles.find params[:id]
    end

    def set_assignee_filters
      params[:assignee_ids] = nil if status_filter_param.unassigned?
      @assignee_filters = Current.account.users.where(id: params[:assignee_ids]) if params[:assignee_ids]
    end

    def status_filter_param
      params.fetch(:status, "")&.inquiry
    end
    helper_method :status_filter_param

    def set_tag_filters
      @tag_filters = Current.account.tags.where(id: params[:tag_ids]) if params[:tag_ids]
    end

    def bubble_params
      params.require(:bubble).permit(:title, :color, :due_on, :image, tag_ids: [])
    end
end
