class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :csv_id
      t.string :category_name
      t.integer :name_length
      t.integer :description_length
      t.integer :photos_qty
      t.integer :weight_g
      t.integer :length_cm
      t.integer :height_cm
      t.integer :width_cm

      t.timestamps
    end

    add_index :products, :csv_id, unique: true
  end
end
