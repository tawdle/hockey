class AddPosterToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :poster_key, :string
    Video.update_all("poster_key = regexp_replace(thumb_key, 'thumbs/', 'posters/')")
  end

  def down
    remove_column :videos, :poster_key, :string
  end
end

