class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.string :order_csv_id
      t.integer :csv_id
      t.string :product_csv_id
      t.string :seller_csv_id
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.datetime :shipping_limit_at
      t.float :price
      t.float :freight_value

      t.timestamps
    end
  end
end
