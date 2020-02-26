class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :csv_id
      t.string :uid
      t.string :zip_code_prefix
      t.string :city
      t.string :state

      t.timestamps
    end

    add_index :customers, :csv_id, unique: true
  end
end
