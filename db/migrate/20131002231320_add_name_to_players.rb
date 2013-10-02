class AddNameToPlayers < ActiveRecord::Migration
  def up
    add_column :players, :name, :string
    Player.all.each do |player|
      player.update_attribute(:name, "Player #{player.id}")
    end
  end
  def down
    remove_column :players, :name
  end
end
