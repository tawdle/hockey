class Feed::NewFollowing < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"

  attr_accessible :user, :target

  validates_presence_of :user
  validates_presence_of :target_name

  def target=(obj)
    @target = obj
    self.target_name = @target.feed_name
  end

  def target
    @target
  end

  def message
    I18n.t "feed.new_following", user: user.feed_name, target: target_name
  end

  def mentioned_objects
    [user, target]
  end
end


