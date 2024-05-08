class ChangeBasePriceToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :flights, :base_price, :integer
  end
end
