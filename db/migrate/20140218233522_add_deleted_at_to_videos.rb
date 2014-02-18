class AddDeletedAtToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :deleted_at, :timestamp
  end
end
