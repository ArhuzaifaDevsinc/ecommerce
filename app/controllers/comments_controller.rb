# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :fetch_comment, only: %i[edit update destroy]
  def create
    @item = Item.find(params[:item_id])
    @comment = @item.comments.create(comment_params)
    redirect_to item_path(@item), alert: 'Something went wrong! Please comment again!' and return unless @item.save
  end

  def edit
    authorize @comment
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

  private

  def fetch_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:description, :user_id)
  end
end
