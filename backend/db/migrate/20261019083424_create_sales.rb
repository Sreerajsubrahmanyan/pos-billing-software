class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :user, null: false, foreign_key: true

      t.string :bill_number, null: false
      t.decimal :subtotal, precision: 12, scale: 2, null: false
      t.decimal :tax_amount, precision: 12, scale: 2, null: false, default: 0
      t.decimal :discount_amount, precision: 12, scale: 2, null: false, default: 0
      t.decimal :total_amount, precision: 12, scale: 2, null: false
      t.string :payment_method, null: false
      t.string :status, null: false, default: "completed"

      t.timestamps
    end

    add_index :sales, :bill_number, unique: true
  end
end