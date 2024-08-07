require 'pago'
class OrdersController < ApplicationController
  skip_before_action :authorize, only: %i[ new create ]
  include CurrentCart
  before_action :set_cart, only: %i[ new create ]
  before_action :ensure_cart_isnt_empty, only: %i[ new ]
  before_action :set_order, only: %i[ show edit update destroy ]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
  end


  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(@cart)

    respond_to do |format|
      if @order.save
        payment_data = payment_params
        Rails.logger.debug("Payment data: #{payment_data}")
        ChargeOrderJob.perform_later(@order, payment_data)
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to store_index_url, notice: 'Thank you for your order.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


  private

def ensure_cart_isnt_empty
  if @cart.line_items.empty?
    redirect_to store_index_url, notice: 'Your cart is empty'
  end
end

  def order_params
    params.require(:order).permit(:name, :address, :email, :payment_type_id)
  end

  def payment_params
    Rails.logger.debug "Payment params: #{params[:order][:payment_type_id]}"
    case params[:order][:payment_type_id].to_i
    when 1 # Cash
      params.require(:order).permit(:cash_amount)
    when 2 # Coupon
      params.require(:order).permit(:coupon_code)
    when 3 # Check
      params.require(:order).permit(:routing_number, :account_number)
    when 4 # Credit card
      params.require(:order).permit(:credit_card_number, :expiration_date)
    when 5 # Purchase order
      params.require(:order).permit(:po_number)
    else
      {}
    end
  end



  end


