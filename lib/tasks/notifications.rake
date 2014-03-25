namespace :notifications do
  namespace :new_feed_items do
    def new_feed_items_for(user)
      items = ActivityFeedItem.for_user(user).where("(activity_feed_items.creator_id is null OR activity_feed_items.creator_id <> ?)", user.id)
      items = items.where("activity_feed_items.created_at > ?", user.last_viewed_home_page_at) if user.last_viewed_home_page_at
      items = items.where("activity_feed_items.created_at > ?", user.last_activity_feed_notification_sent_at) if user.last_activity_feed_notification_sent_at
      items
    end

    task :show => :environment do
      User.find_each do |user|
        new_feed_items_for(user).each do |item|
          puts "#{user.at_name}: (#{item.id}) #{item.message}"
        end
      end
    end
    task :send => :environment do
      User.order(:id).where(:subscribed_daily_activity_feed => true).find_each do |user|
        mark_time = Time.now
        items = new_feed_items_for(user)
        if items.any?
          NotificationMailer.new_feed_items(user, items).deliver
          user.update_attribute(:last_activity_feed_notification_sent_at, mark_time)
        end
      end
    end
  end
end
