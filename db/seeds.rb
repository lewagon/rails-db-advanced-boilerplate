require 'csv'

puts "parsing products..."
products = []
CSV.foreach('db/brazilian-ecommerce/olist_products_dataset.csv', headers: true) do |row|
  print "."
  products << Product.new(row.to_hash)
end

puts "\nimporting #{products.size} products..."
Product.import products
puts "done!"

puts "parsing sellers..."
sellers = []
CSV.foreach('db/brazilian-ecommerce/olist_sellers_dataset.csv', headers: true) do |row|
  print "."
  sellers << Seller.new(row.to_hash)
end

puts "\nimporting #{sellers.size} sellers..."
Seller.import sellers
puts "done!"

puts "parsing customers..."
customers = []
CSV.foreach('db/brazilian-ecommerce/olist_customers_dataset.csv', headers: true) do |row|
  print "."
  customers << Customer.new(row.to_hash)
end

puts "\nimporting #{customers.size} customers..."
Customer.import customers
puts "done!"

puts "parsing orders..."
offset = (Date.today - Date.new(2017, 3, 1)).to_i
orders = []
CSV.foreach('db/brazilian-ecommerce/olist_orders_dataset.csv', headers: true) do |row|
  next if row["purchased_at"].nil? || row["purchased_at"] < "2017-03-01" || row["purchased_at"] > "2018-03-31"

  print "."
  order = Order.new(row.to_hash)
  order.customer = Customer.find_by(csv_id: row["customer_csv_id"])
  order.purchased_at = order.purchased_at + offset.days
  orders << order
end

puts "\nimporting #{orders.size} orders..."
Order.import orders
puts "done!"


puts "parsing order items..."
order_items = []
CSV.foreach('db/brazilian-ecommerce/olist_order_items_dataset.csv', headers: true) do |row|
  order_item = OrderItem.new(row.to_hash)
  order_item.order = Order.find_by(csv_id: row["order_csv_id"])
  next if order_item.order.nil?

  print "."
  order_item.product = Product.find_by(csv_id: row["product_csv_id"])
  order_item.seller = Seller.find_by(csv_id: row["seller_csv_id"])
  order_items << order_item
end

puts "\nimporting #{order_items.size} order_items..."
OrderItem.import order_items
puts "done!"

puts "parsing payments..."
order_payments = []
CSV.foreach('db/brazilian-ecommerce/olist_order_payments_dataset.csv', headers: true) do |row|
  print "."
  order_payment = OrderPayment.new(row.to_hash)
  order_payment.order = Order.find_by(csv_id: row["order_csv_id"])
  order_payments << order_payment
end

puts "\nimporting #{order_payments.size} order_payments..."
OrderPayment.import order_payments
puts "done!"

