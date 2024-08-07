class CartsController < ApplicationController
  skip_before_action :authorize, only: %i[ create update destroy ]
  include ActionView::RecordIdentifier
  before_action :set_cart, only: %i[ show edit update destroy increase_quantity decrease_quantity ]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  # GET /carts or /carts.json
  def index
    @carts = Cart.all
    
  end

  # GET /carts/1 or /carts/1.json
  def show
    if @cart.id == session[:cart_id]
      @cart = Cart.find(session[:cart_id])
    else
      redirect_to store_index_url, notice: 'Invalid cart'
    end 
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # PATCH /carts/1/increase_quantity
  def increase_quantity
    @current_item = @cart.line_items.find(params[:line_item_id])
    @current_item.increment!(:quantity)

    Rails.logger.debug "Increased quantity of item #{@current_item.id} to #{@current_item.quantity}"
    respond_to do |format|
      format.turbo_stream { render 'carts/increase_quantity', locals: { line_item: @current_item, cart: @cart, current_item: @current_item } }
      format.html { redirect_to cart_url(@cart) }
    end
  end

  # PATCH /carts/1/decrease_quantity
  def decrease_quantity
    @current_item = @cart.line_items.find(params[:line_item_id])
    if @current_item.quantity > 1
      @current_item.decrement!(:quantity)
    else
      @current_item.destroy
    end
    Rails.logger.debug "Decreased quantity of item #{@current_item.id}. Remaining items: #{@current_item.quantity}"

    respond_to do |format|
      if @current_item.destroyed?
        format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@current_item)) }
      else
        format.turbo_stream { render 'carts/decrease_quantity', locals: { line_item: @current_item, cart: @cart, current_item: @current_item } }
      end
      format.html { redirect_to cart_url(@cart) }
    end
  end


  # POST /carts or /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to cart_url(@cart), notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to cart_url(@cart), notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy if @cart.id == session[:cart_id] 
      session[:cart_id] = nil
      respond_to do |format|
      format.html { redirect_to store_index_url,
      notice: 'Your cart is currently empty' } 
      format.json { head :no_content }
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.fetch(:cart, {})
    end
    
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}" 
      redirect_to store_index_url, notice: 'Invalid cart'
    end
end
