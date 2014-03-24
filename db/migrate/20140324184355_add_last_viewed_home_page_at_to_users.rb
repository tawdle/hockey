class AddLastViewedHomePageAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_viewed_home_page_at, :datetime
  end
end
