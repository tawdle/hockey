class AddUnsubscribeToUsers < ActiveRecord::Migration
  def up
    add_column :users, :unsubscribe_token, :string
    add_column :users, :subscribed_daily_activity_feed, :boolean, :null => false, :default => true
    add_index :users, :unsubscribe_token, :unique => true

    User.find_each do |user|
      user.update_attribute(:unsubscribe_token, RandomToken.generate)
    end
  end

  def down
    remove_column :users, :subscribed_daily_activity_feed
    remove_column :users, :unsubscribe_token
  end
end
