class ActivityFeedItem < ActiveRecord::Base
  belongs_to :game, :inverse_of => :activity_feed_items
  has_many :mentions, :dependent => :destroy, :inverse_of => :activity_feed_item

  attr_accessible :game, :game_id

  before_create :build_mentions
  after_create :broadcast_changes

  default_scope order("created_at desc")

  UserIdsForFollowedUsers = "SELECT followings.followable_id
                             FROM followings
                             WHERE followings.user_id = ? AND followings.followable_type = 'User'"

  def self.for(obj)
    if obj.is_a?(User)
      # XXX: This needs some attention now that mentionable/followable have been introduced.
      # Can't I just do this as a 3-way join (activity_feed_item to mentions to followings)?
      # Find activity feeed items that
      # (1) were created by user or
      # (2) were created by someone this user follows or
      # (3) mention this user or
      joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
        where("creator_id = ? OR
               creator_id IN (#{UserIdsForFollowedUsers}) OR
               (mentions.mentionable_id = ? AND mentions.mentionable_type = ?)",
              obj.id, obj.id, obj.id, obj.class.name)
    else
      joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
        where(mentions: { mentionable_id: obj.id, mentionable_type: obj.class.name })
    end
  end

  scope :for_game, lambda {|game| where(:game_id => game.id) }
  scope :system, where("type != 'Feed::UserPost'")

  def avatar_url(version_name = nil)
   User.new.avatar_url(version_name)
  end

  def active_model_serializer
    ActivityFeedItemSerializer
  end

  private

  def mentioned_objects
    throw "must be implemented by subclasses"
  end

  def build_mentions
    add_mentioned_objects(mentioned_objects)
  end

  def add_mentioned_objects(arr)
    mentions.concat(arr.map {|obj| Mention.new(mentionable: obj) })
  end

  def broadcast_changes
    game.send(:broadcast_changes, :with => [:activity_feed_items]) if game
  end
end
