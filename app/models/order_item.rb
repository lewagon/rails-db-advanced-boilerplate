class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :seller
end
