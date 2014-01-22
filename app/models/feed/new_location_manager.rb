class Feed::NewLocationManager < ActivityFeedItem
  belongs_to :user, foreign_key: "subject_id"
  belongs_to :location, foreign_key: "target_id"

  attr_accessible :user, :location

  validates_presence_of :user
  validates_presence_of :location

  def message
    I18n.t "feed.new_location_manager", user: user.at_name, location: location.at_name
  end

  def mentioned_objects
    [user, location]
  end
end
