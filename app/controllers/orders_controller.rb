class OrdersController < ApplicationController
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
      payment_type = PaymentType.find_by(id: params[:order][:payment_type_id])
      @payment = Payment.new(
        payment_type: payment_type,
        order: @order,
        data: payment_params
      )

      if @payment.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderMailer.received(@order).deliver_later
        format.html { redirect_to store_index_url, notice:
          'Thank you for your order.' }
        format.json { render :show, status: :created,
                             location: @order }
      else
        @order.destroy  # Clean up in case payment fails
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors,
                             status: :unprocessable_entity }
      end
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @order.errors,
                           status: :unprocessable_entity }
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
    case params[:order][:payment_type_id].to_i
    when 1 # Credit card
      params.require(:order).permit(:credit_card_number, :expiration_date)
    when 2 # Check
      params.require(:order).permit(:routing_number, :account_number)
    when 3 # Purchase order
      params.require(:order).permit(:po_number)
    when 4 # Cash
      params.require(:order).permit(:cash_amount)
    when 5 # Coupon
      params.require(:order).permit(:coupon_code)
    else
      {}
    end
  end
  end


