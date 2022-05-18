class Categories::DiscussionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @category = Category.find params[:id]
    @discussions = @category.discussions.order(updated_at: :desc)
    @categories = Category.all.sorted.with_discussions_count
    render "discussions/index"
  end

end