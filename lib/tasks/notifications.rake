namespace :notifications do
  namespace :new_feed_items do
    def new_feed_items_for(user)
      items = ActivityFeedItem.for_user(user)
      mindate = [user.last_viewed_home_page_at, user.last_activity_feed_notification_sent_at].compact.min
      items = items.before(mindate) if mindate
      items
    end

    task :show => :environment do
      msgs = []
      User.find_each do |user|
        new_feed_items_for(user).each do |item|
          msgs.append "#{user.at_name}: (#{item.id}) #{item.message}"
        end
      end
      msgs.each {|m| puts m }
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
