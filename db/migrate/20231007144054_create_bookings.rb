class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.integer :no_of_seats, null:false
      t.integer :seat_price,null:false
      t.references :user,foreign_key:true,index:true
      t.references :flight,foreign_key:true,index:true
      t.timestamps
    end
  end
end
