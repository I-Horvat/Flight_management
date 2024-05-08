class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.string :name, null: false
      t.integer :no_of_seats
      t.decimal :base_price, precision: 10, scale: 2, null: false
      t.datetime :departs_at, null: false
      t.datetime :arrives_at
      t.references :company, foreign_key: true, index: true
      t.timestamps
    end
  end
end
