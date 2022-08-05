class ItemsController < ApplicationController
  before_action :fetch_id, only: [:show, :edit, :update, :destroy]
  before_action :initialize_session
  before_action :delete_item_from_session, only: [:destroy]
  before_action :load_cart

  def index
    @items = Item.all
    # @visit_count =1
    session[:visit_count] ||= 0
    session[:visit_count] += 1
    @visit_count = session[:visit_count]
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

  def add_to_cart
    id = params[:id].to_i
    @item = Item.find(id)
    
    if current_user == @item.user
      flash[:errors] = "User can't add his own item into cart!"
      redirect_to root_path

    else
      session[:cart] << id
      redirect_to root_path
    end
  end

  def remove_from_cart
    delete_item_from_session
    redirect_back(fallback_location: root_path)
  end

  def line_item_add
    id= session[:quantity]
    id=id.to_i
    id += 1
    session[:quantity] = id
    @quantity=id
    redirect_to root_path
  end

  def line_item_reduce
    id = session[:quantity]
    id = id.to_i
    id -= 1
    session[:quantity] = id
    @quantity = id
    redirect_to root_path
  end

  private

  def delete_item_from_session
    session[:cart].delete(params[:id])
  end

  def fetch_id
    @item = Item.find(params[:id])
  end

  def initialize_session
    session[:cart] ||= []
    session[:quantity] ||= 1
  end

  def load_cart
    @cart = Item.find(session[:cart])
    @quantity = session[:quantity]
  end

  def item_params
    params.require(:item).permit(:title, :description, :price, :serial_no, images: [])
  end
end
