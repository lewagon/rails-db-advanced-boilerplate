class AddNameToSellers < ActiveRecord::Migration[6.0]
  def change
    add_column :sellers, :name, :string

    Seller.find_each do |seller|
      seller.update(name: Faker::Company.name)
    end
  end
end
