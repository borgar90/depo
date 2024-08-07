class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :user
  # Validations
  validates :name, :address, :email, presence: true


  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def charge!(payment_data)
    payment_details = {}
    payment_method = nil

    case payment_type_name
    when "Check"
      payment_method = :check
      payment_details[:routing] = payment_data[:routing_number]
      payment_details[:account] = payment_data[:account_number]
    when "Credit card"
      if payment_data[:expiration_date].present?
        month, year = payment_data[:expiration_date].split('/')
        payment_details[:expiration_month] = month
        payment_details[:expiration_year] = year
      else
        raise "Invalid expiration date"
      end
      payment_method = :credit_card
      payment_details[:cc_num] = payment_data[:credit_card_number]
      Rails.logger.debug "Payment details: #{payment_details}"
      Rails.logger.debug "Payment data: #{payment_data}"
    when "Purchase order"
      payment_method = :po
      payment_details[:po_num] = payment_data[:po_number]
    end

    payment_result = Pago.make_payment(
      order_id: id,
      payment_method: payment_method,
      payment_details: payment_details
    )
    Rails.logger.debug "Order result: #{self.line_items}"
    if payment_result.succeeded?
      OrderMailer.received(self).deliver_later
    else
      raise payment_result.error
    end
  end

  def payment_type_name
    PaymentType.find(payment_type_id).name
  end


  # Method to get payment type options
  def self.payment_type_options
    PaymentType.pluck(:name, :id)
  end


end