class Discussions::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion
  before_action :set_post, only: [:show, :create, :new, :edit, :update, :destroy]

  def create
    respond_to do |format|
      if @post.update(post_params)
        @post.broadcast_append_to @discussion, partial: "discussions/posts/post", locals: { post: @post }
        format.html { redirect_to discussion_path(@discussion), notice: "Post created" }
      else
        format.turbo_stream {  }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def set_post
    @post = @discussion.posts.new(user: Current.user)
  end

  def set_discussion
    @discussion = Discussion.find params[:discussion_id]
  end

end