class NormalizeIndices < ActiveRecord::Migration
  def up
    execute("DROP INDEX index_users_on_email")
    execute("CREATE UNIQUE INDEX index_users_on_email ON users USING btree (lower((email)::text))")
  end

  def down
  end
end
