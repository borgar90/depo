class CreateReturnOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :return_orders do |t|
      t.string :reason

      t.timestamps
    end
  end
end
