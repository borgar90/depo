class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.string :phone
      t.text :shipping_info

      t.timestamps
    end
  end
end
