class CreateOrderPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :order_payments do |t|
      t.string :order_csv_id
      t.references :order, null: false, foreign_key: true
      t.integer :payment_sequential
      t.string :payment_type
      t.integer :payment_installments
      t.float :payment_value

      t.timestamps
    end
  end
end
