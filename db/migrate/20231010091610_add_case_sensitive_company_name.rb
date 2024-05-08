class AddCaseSensitiveCompanyName < ActiveRecord::Migration[6.1]
  def change
    add_index :companies, 'lower(name)',unique: true
  end
end
