class AddNoFollowingsNotificationSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :no_followings_notification_sent_at, :datetime
  end
end
