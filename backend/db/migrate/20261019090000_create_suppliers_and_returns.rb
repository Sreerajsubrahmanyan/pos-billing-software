class CreateSuppliersAndReturns < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers do |t|
      t.string :name, null: false
      t.string :contact_name
      t.string :phone
      t.string :email
      t.text :address
      t.string :status, null: false, default: "active"
      t.timestamps
    end

    create_table :returns do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :refund_amount, precision: 12, scale: 2, null: false
      t.string :reason, null: false
      t.timestamps
    end
  end
end
