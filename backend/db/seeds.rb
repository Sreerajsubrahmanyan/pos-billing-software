admin = User.find_or_initialize_by(email: "admin@loomandlane.demo")
admin.assign_attributes(name: "Store Admin", role: "admin", password: "LoomAdmin!2026", password_confirmation: "LoomAdmin!2026")
admin.save!

staff = User.find_or_initialize_by(email: "cashier@loomandlane.demo")
staff.assign_attributes(name: "Aarav Sharma", role: "staff", password: "Cashier!2026", password_confirmation: "Cashier!2026")
staff.save!

[
  ["Indigo Handloom Saree", "TX-1001", "Handwoven cotton silk · Indigo", 2499, 12],
  ["Block Print Kurta", "TX-1002", "Ajrakh block print · Cotton", 1299, 24],
  ["Linen Shirt", "TX-1003", "Natural linen · Relaxed fit", 1899, 4],
  ["Silk Dupatta", "TX-1004", "Mulberry silk · Hand finished", 999, 18],
  ["Everyday Cotton Tote", "TX-1005", "Hand printed · Reusable", 399, 32],
  ["Chanderi Festive Set", "TX-1006", "Chanderi blend · Festive wear", 3299, 6]
].each do |name, sku, description, price, stock|
  Product.find_or_create_by!(sku: sku) do |product|
    product.assign_attributes(name: name, description: description, price: price, stock_quantity: stock)
  end
end

Supplier.find_or_create_by!(name: "Kaveri Weaves") do |supplier|
  supplier.assign_attributes(contact_name: "Meera Iyer", phone: "+91 98765 43210", email: "orders@kaveriweaves.example", address: "Coimbatore, Tamil Nadu")
end
