class MakeEmailCaseInsensitive < ActiveRecord::Migration[6.1]
  def change
    execute <<-SQL
      CREATE UNIQUE INDEX index_users_on_lower_email ON users (lower(email));
    SQL
  end
end
