class AddPaymentTypeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :payment_type, null: false, foreign_key: true
  end


end
