class FeedUserPosts < ActiveRecord::Migration
  def up
    ActivityFeedItem.update_all("type = 'Feed::UserPost'", "creator_id is not null");
  end

  def down
    ActivityFeedItem.update_all("type = null", "type = 'Feed::UserPost'")
  end
end
