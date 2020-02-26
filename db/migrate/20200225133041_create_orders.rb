class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :csv_id
      t.string :customer_csv_id
      t.string :status
      t.references :customer, null: false, foreign_key: true
      t.datetime :purchased_at
      t.datetime :approved_at
      t.datetime :delivered_to_carrier_at
      t.datetime :delivered_to_customer_at
      t.datetime :estimated_delivery_at

      t.timestamps
    end

    add_index :orders, :csv_id, unique: true
  end
end
