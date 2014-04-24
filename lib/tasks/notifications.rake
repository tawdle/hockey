namespace :notifications do
  namespace :new_feed_items do
    def new_feed_items_for(user)
      items = ActivityFeedItem.for_user(user)
      mindate = [user.last_viewed_home_page_at, user.last_activity_feed_notification_sent_at].compact.max
      items = items.after(mindate) if mindate
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
        if Following.followables_for(user).any?
          items = new_feed_items_for(user).all
          if items.any?
            NotificationMailer.new_feed_items(user, items).deliver
            user.update_attribute(:last_activity_feed_notification_sent_at, mark_time)
          end
        elsif user.last_activity_feed_notification_sent_at.nil?
          NotificationMailer.no_follows(user).deliver
          user.update_attribute(:last_activity_feed_notification_sent_at, mark_time)
        end
      end
    end
  end
  namespace :invitations do
    task :send => :environment do
      Invitation.where(:state => :pending).where("greatest(created_at, last_reminder_sent_at) < ?", 1.week.ago).each do |invitation|
        InvitationMailer.remind(invitation).deliver
        invitation.update_attribute(:last_reminder_sent_at, Time.now)
      end
    end
  end
end
