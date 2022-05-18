class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, except: :index
  before_action :set_categories

  def index
    @discussions = Discussion.all.with_posts_count.ordered.includes(:category)
  end

  def show
    @posts = @discussion.posts.order(:created_at).includes(:user, :rich_text_body)
    @new_post = @discussion.posts.new
  end

  def new
    @discussion.posts.new
  end

  def create
    @discussion = Discussion.new(discussion_params)
    respond_to do |format|
      if @discussion.save
        @discussion.broadcast_prepend_to("discussions")
        if @discussion.category_id
          @discussion.broadcast_prepend_to(@discussion.category)
          @discussion.category.broadcast_replace_to "categories"
        end
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
        if @discussion.saved_change_to_category_id?
          old_category_id, new_category_id = @discussion.saved_change_to_category_id
          old_category = Category.find old_category_id
          new_category = Category.find new_category_id

          @discussion.broadcast_remove_to old_category
          @discussion.broadcast_prepend_to new_category
          old_category.broadcast_replace_to "categories"
          new_category.broadcast_replace_to "categories"
        end
        @discussion.broadcast_replace_to("discussions")
        @discussion.broadcast_replace_to @discussion
        @discussion.broadcast_replace_to @discussion,
          target: "new_post_form",
          partial: "discussions/posts/form",
          locals: { post: @discussion.posts.new }
        format.html do
          redirect_to @discussion, notice: "Discussion updated"
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    category = @discussion.category
    @discussion.destroy!
    if category
      @discussion.broadcast_remove_to(category)
      category.broadcast_replace_to "categories"
    end
    @discussion.broadcast_remove_to("discussions")
    redirect_to discussions_path, notice: "Discussion removed"
  end

  private

  def discussion_params
    params.require(:discussion).permit(:name, :user_id, :category_id, :pinned, :closed, posts_attributes: [:user_id, :body])
  end

  def set_discussion
    @discussion = if params[:id]
      Discussion.find params[:id]
    else
      Discussion.new
    end
  end

  def set_categories
    @categories = Category.all.ordered.with_discussions_count
  end
end