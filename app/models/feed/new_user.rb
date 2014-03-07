class Feed::NewUser < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"

  attr_accessible :user

  validates_presence_of :user

  def message
    I18n.t "feed.new_user", user: user.feed_name
  end

  def mentioned_objects
    [user]
  end
end

