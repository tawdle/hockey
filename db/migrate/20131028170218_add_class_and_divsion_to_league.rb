class AddClassAndDivsionToLeague < ActiveRecord::Migration
  def up
    add_column :leagues, :classification, :string
    add_column :leagues, :division, :string
    League.update_all("classification = 'AAA'")
    League.update_all("division = 'midget'")
  end

  def down
    remove_column :leagues, :classification
    remove_column :leagues, :division
  end
end
