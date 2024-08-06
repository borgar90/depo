class Order < ApplicationRecord
  belongs_to :payment, optional: true
  has_many :line_items, dependent: :destroy

  # Validations
  validates :name, :address, :email, presence: true
  validate :validate_payment_fields

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  # Method to get payment type options
  def self.payment_type_options
    PaymentType.pluck(:name, :id)
  end

  private

  def validate_payment_fields
    return unless payment

    case payment.payment_type.name
    when 'Credit card'
      errors.add(:credit_card_number, 'is required') if payment.data['credit_card_number'].blank?
      errors.add(:expiration_date, 'is required') if payment.data['expiration_date'].blank?
    when 'Check'
      errors.add(:routing_number, 'is required') if payment.data['routing_number'].blank?
      errors.add(:account_number, 'is required') if payment.data['account_number'].blank?
    when 'Purchase order'
      errors.add(:po_number, 'is required') if payment.data['po_number'].blank?
    when 'Cash'
      errors.add(:cash_amount, 'is required') if payment.data['cash_amount'].blank?
    when 'Coupon'
      errors.add(:coupon_code, 'is required') if payment.data['coupon_code'].blank?
    end
  end
end