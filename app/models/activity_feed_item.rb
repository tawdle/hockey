class ActivityFeedItem < ActiveRecord::Base
  belongs_to :parent, :class_name => "ActivityFeedItem"
  has_many :children, :class_name => "ActivityFeedItem", :foreign_key => :parent_id
  belongs_to :game, :inverse_of => :activity_feed_items
  has_many :mentions, :dependent => :destroy, :inverse_of => :activity_feed_item
  has_many :videos, :foreign_key => :feed_item_id, :conditions => {:deleted_at => nil }

  attr_accessible :game, :game_id, :parent_id

  before_create :build_mentions
  after_create :broadcast_changes

  default_scope order("created_at desc")
  scope :top_level, where(:parent_id => nil)

  def self.for_user(user)
    id = user.id
    top_level.
      includes(:children).
      joins("left outer join mentions on mentions.activity_feed_item_id = activity_feed_items.id").
      joins("left outer join followings f1 on f1.followable_id = mentions.mentionable_id and f1.followable_type = mentions.mentionable_type").
      joins("left outer join followings f2 on f2.followable_id = activity_feed_items.creator_id and f2.followable_type = 'User'").
      joins("left outer join players on mentions.mentionable_type = 'Player' and mentions.mentionable_id = players.id").
      where("activity_feed_items.creator_id = ? or f1.user_id = ? or f2.user_id = ? or (mentions.mentionable_type = 'User' and mentions.mentionable_id = ?) or players.user_id = ?",
            id, id, id, id, id).
      select('distinct "activity_feed_items".*')
  end

  def self.for(obj)
    case obj
    when User
      top_level.
        includes(:children).
        joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
        where("creator_id = ? or (mentions.mentionable_id = ? and mentions.mentionable_type = 'User')", obj.id, obj.id).
        select('distinct "activity_feed_items".*')
    else
      top_level.
        includes(:children).
        joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
        where(mentions: { mentionable_id: obj.id, mentionable_type: obj.class.name }).
        select('distinct "activity_feed_items".*')
    end
  end

  scope :for_game, lambda {|game| where(:game_id => game.id) }
  scope :system_generated, where("type != 'Feed::UserPost'")

  def avatar_url(version_name = nil)
   User.new.avatar_url(version_name)
  end

  def title
    ApplicationController.helpers.format_message_text_only(message)
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
