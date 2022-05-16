class DiscussionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @discussions = Discussion.all.order(updated_at: :desc)
  end

  def show
    @discussion = Discussion.find params[:id]
  end

  def new
    @discussion = Discussion.new
  end

  def create
    @discussion = Discussion.new(discussion_params.merge(user: Current.user))
    respond_to do |format|
      if @discussion.save
        @discussion.broadcast_prepend_to("discussions")
        format.html { redirect_to @discussion, notice: "Discussion created" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @discussion = Discussion.find params[:id]
  end

  def update
    @discussion = Discussion.find params[:id]
    respond_to do |format|
      if @discussion.update(discussion_params)
        @discussion.broadcast_replace_to("discussions")
        format.html { redirect_to @discussion, notice: "Discussion updated" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discussion = Discussion.find params[:id]
    @discussion.destroy!
    @discussion.broadcast_remove_to("discussions")
    redirect_to discussions_path, notice: "Discussion removed"
  end

  private

  def discussion_params
    params.require(:discussion).permit(:name, :pinned, :closed)
  end
end