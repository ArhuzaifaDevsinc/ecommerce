class CommentsController < ApplicationController
  before_action :fetch_comment_id, only: [:edit, :update, :destroy]
  def create
    @item=Item.find(params[:item_id])
    @comment = @item.comments.create(comment_params)
    if @item.save
      redirect_to item_path(@item)
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to item_path(@comment.item.id)
    else
      render edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to item_path(@comment.item.id)
  end
  def fetch_comment_id
   
    @comment=Comment.find(params[:id])
  end
  private
    def comment_params
      params.require(:comment).permit(:description, :user_id)
    end
end

