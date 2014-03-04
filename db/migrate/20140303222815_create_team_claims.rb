class CreateTeamClaims < ActiveRecord::Migration
  def up
    create_table :team_claims, :id => false do |t|
      t.string :code, :nil => false
      t.references :team, :nil => false
      t.datetime :expires_at
      t.timestamps
    end
    execute "ALTER TABLE team_claims ADD PRIMARY KEY (code);"
    add_index :team_claims, :team_id
  end

  def down
    drop_table :team_claims
  end
end
