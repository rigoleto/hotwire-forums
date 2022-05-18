class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, except: :index

  def index
    @discussions = Discussion.all.with_posts_count.order(updated_at: :desc)
  end

  def show
    @posts = @discussion.posts.order(:created_at)
    @new_post = @discussion.posts.new
  end

  def new
    @categories = Category.all.sorted
  end

  def create
    @discussion = Discussion.new(discussion_params.merge(user: Current.user))
    respond_to do |format|
      if @discussion.save
        @discussion.broadcast_prepend_to("discussions")
        format.html do
          redirect_to @discussion, notice: "Discussion created"
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        @discussion.broadcast_replace_to("discussions")
        format.html do
          redirect_to @discussion, notice: "Discussion updated"
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discussion.destroy!
    @discussion.broadcast_remove_to("discussions")
    redirect_to discussions_path, notice: "Discussion removed"
  end

  private

  def discussion_params
    params.require(:discussion).permit(:name, :category_id, :pinned, :closed, post_attributes: :body)
  end

  def set_discussion
    @discussion = if params[:id]
      Discussion.find params[:id]
    else
      Discussion.new
    end
  end
end