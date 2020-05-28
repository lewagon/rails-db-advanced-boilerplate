require 'csv'

def import_items(elements, mapping = true)
  puts "      Importing #{elements.size} #{elements.first.class.name.downcase.pluralize}..."
  elements.first.class.import elements
  puts "      Done!"
  elements.first.class.pluck(:csv_id, :id).to_h if mapping
end

def parse_items(klass, step)
  pluralized_name = klass.name.downcase.pluralize
  puts "[#{step}/6] Parsing #{pluralized_name}..."
  elements = []
  CSV.foreach("db/brazilian-ecommerce/olist_#{pluralized_name}_dataset.csv", headers: true) do |row|
    row["name"] = Faker::Company.name if klass == Seller
    elements << klass.new(row.to_hash)
  end
  import_items(elements)
end

product_ids_mapping  = parse_items(Product,  1)
seller_ids_mapping   = parse_items(Seller,   2)
customer_ids_mapping = parse_items(Customer, 3)
GC.start

puts "[4/6] Parsing orders..."
orders = []
CSV.foreach('db/brazilian-ecommerce/olist_orders_dataset.csv', headers: true) do |row|
  next if row["purchased_at"].nil? || row["purchased_at"] < "2017-03-01" || row["purchased_at"] > "2018-03-31"

  order = Order.new(row.to_hash)
  order.customer_id = customer_ids_mapping[row["customer_csv_id"]]
  orders << order
end
order_ids_mapping = import_items(orders)
GC.start


puts "[5/6] Parsing order items..."
order_items = []
CSV.foreach('db/brazilian-ecommerce/olist_order_items_dataset.csv', headers: true) do |row|
  order_item = OrderItem.new(row.to_hash)
  order_item.order_id = order_ids_mapping[row["order_csv_id"]]
  next if order_item.order.nil?

  order_item.product_id = product_ids_mapping[row["product_csv_id"]]
  order_item.seller_id = seller_ids_mapping[row["seller_csv_id"]]
  order_items << order_item
end
import_items(order_items, false)
GC.start

puts "[6/6] Parsing payments..."
order_payments = []
CSV.foreach('db/brazilian-ecommerce/olist_order_payments_dataset.csv', headers: true) do |row|
  order_payment = OrderPayment.new(row.to_hash)
  order_payment.order_id = order_ids_mapping[row["order_csv_id"]]
  order_payments << order_payment
end
import_items(order_payments, false)

puts "Completed global import"
