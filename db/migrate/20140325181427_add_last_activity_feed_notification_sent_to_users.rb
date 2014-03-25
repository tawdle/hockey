class AddLastActivityFeedNotificationSentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_activity_feed_notification_sent_at, :datetime
  end
end
