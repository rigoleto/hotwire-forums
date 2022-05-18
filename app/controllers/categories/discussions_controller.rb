class Categories::DiscussionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @category = Category.find params[:id]
    @discussions = @category.discussions.ordered
    @categories = Category.all.ordered.with_discussions_count
    render "discussions/index"
  end

end