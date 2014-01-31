class AddVimeoIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :vimeo_id, :string
  end
end
