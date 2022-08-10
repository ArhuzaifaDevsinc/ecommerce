class ItemsController < ApplicationController
  before_action :fetch_item, only: [:show, :edit, :update, :destroy]
  before_action :delete_item_from_session, only: [:destroy]
 
  def index
    @items = Item.all
  end

  def search
    @query = params[:title]
    @items = Item.where("title LIKE'%#{params[:title]}%'")
  end

  def new
    @item = Item.new
  end

  def create
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
    authorize @item
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

  private

  def delete_item_from_session
    session[:cart].delete(params[:id])
  end

  def fetch_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :price, :serial_no, images: [])
  end
end
