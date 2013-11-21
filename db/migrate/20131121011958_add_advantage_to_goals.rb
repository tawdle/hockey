class AddAdvantageToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :advantage, :integer
  end
end
