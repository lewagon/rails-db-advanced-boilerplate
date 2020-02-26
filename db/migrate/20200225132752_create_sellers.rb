class CreateSellers < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers do |t|
      t.string :csv_id
      t.string :zip_code_prefix
      t.string :city
      t.string :state

      t.timestamps
    end

    add_index :sellers, :csv_id, unique: true
  end
end
