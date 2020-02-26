class AddNameToSellers < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers, :name, :string
  end
end
