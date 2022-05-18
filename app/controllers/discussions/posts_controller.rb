class Discussions::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion
  before_action :set_post

  def show

  end

  def create
    respond_to do |format|
      if @post.update(post_params)
        @post.broadcast_append_to @discussion, partial: "discussions/posts/post", locals: { post: @post }
        format.html do
          redirect_to discussion_path(@discussion), notice: "Post created"
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
      if @post.update(post_params)
        format.html { redirect_to discussion_post_path(@discussion, @post), notice: "Post updated" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @post.destroy
        @post.broadcast_remove_to @discussion
        format.html do
          redirect_to discussion_path(@discussion), notice: "Post deleted"
        end
        format.turbo_stream do
          head :no_content
        end
      else
        format.html { redirect_to discussion_path(@discussion), error: "Could not delete post" }
      end
    end
    @post.destroy!
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def set_post
    @post = if params[:id]
      @discussion.posts.find params[:id]
    else
      @discussion.posts.new(user: Current.user)
    end
  end

  def set_discussion
    @discussion = Discussion.find params[:discussion_id]
  end

end