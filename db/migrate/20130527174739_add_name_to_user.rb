class AddNameToUser < ActiveRecord::Migration
  def up
    add_column :users, :name, :string, :null => false
    # See http://stackoverflow.com/questions/7948501/case-insensitive-unique-index-in-rails-activerecord
    execute "CREATE UNIQUE INDEX index_users_on_lowercase_name
             ON users USING btree (lower(name));"
  end

  def down
    execute "DROP INDEX index_users_on_lowercase_name"
  end
end
