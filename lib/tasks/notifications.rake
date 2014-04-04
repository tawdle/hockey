namespace :notifications do
  namespace :new_feed_items do
    def new_feed_items_for(user)
      # The idea here is not to notify users about their own posts. But as written, this logic will exclude posts I wrote
      # that have recent replies from others, which is not what I want.
      items = ActivityFeedItem.for_user(user).where("(activity_feed_items.creator_id is null OR activity_feed_items.creator_id <> ?)", user.id)
      mindate = [user.last_viewed_home_page_at, user.last_activity_feed_notification_sent_at].compact.min
      items = items.having("greatest(activity_feed_items.created_at, max(children.created_at)) < ?", mindate) if mindate
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
