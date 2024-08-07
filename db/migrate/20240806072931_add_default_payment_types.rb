class AddDefaultPaymentTypes < ActiveRecord::Migration[7.0]
  def up
    PaymentType.create(name: 'Cash')
    PaymentType.create(name: 'Coupon')
  end

  def down
    PaymentType.delete_all
  end
end
