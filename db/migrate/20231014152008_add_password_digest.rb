class AddPasswordDigest < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :password_digest, :string
    update_passwords
  end

  def update_passwords
    User.find_each do |user|
      user.update_attribute(:password_digest, BCrypt::Password.create(user.password))
    end
  end

  def down
    remove_column :users, :password_digest
  end
end



