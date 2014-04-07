class MailPreview < MailView
  def new_feed_items
    todd = User.find(1)
    NotificationMailer.new_feed_items(todd, ActivityFeedItem.for_user(todd))
  end
end
