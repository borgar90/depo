class MakePaymentTypeIdNonNullableInOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_null :orders, :payment_type_id, false
  end
end
