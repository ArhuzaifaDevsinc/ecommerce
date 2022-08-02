class ItemsController < ApplicationController
  before_action :fetch_id, only: [:show, :edit, :update, :destroy]
  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    # byebug
    @item = current_user.items.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  def fetch_id
    @item = Item.find(params[:id])
  end
  private
  def item_params
    params.require(:item).permit(:title, :description, :price, :serial_no, images: [])
  end
end
