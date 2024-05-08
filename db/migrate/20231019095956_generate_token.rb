class GenerateToken < ActiveRecord::Migration[6.1]
  def up
    User.all.each do |user|
      user.regenerate_token
    end
    change_column :users, :token, :string, null: false
  end
  def down
    change_column :users, :token, :string, null: true
  end
end
