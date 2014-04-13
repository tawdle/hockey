class ActivityFeedItem < ActiveRecord::Base
  belongs_to :parent, :class_name => "ActivityFeedItem"
  has_many :children, :class_name => "ActivityFeedItem", :foreign_key => :parent_id
  belongs_to :game, :inverse_of => :activity_feed_items
  has_many :mentions, :dependent => :destroy, :inverse_of => :activity_feed_item
  has_many :videos, :foreign_key => :feed_item_id, :conditions => {:deleted_at => nil }

  attr_accessible :game, :game_id, :parent_id

  before_create :build_mentions
  after_create :broadcast_changes

  scope :top_level, where(:parent_id => nil)
  scope :joins_children, joins('left outer join activity_feed_items children on children.parent_id = activity_feed_items.id')
  scope :joins_parent_and_child_mentions, joins("left outer join mentions on mentions.activity_feed_item_id = activity_feed_items.id or mentions.activity_feed_item_id = children.id")
  scope :select_and_group, select('distinct activity_feed_items.*').group('activity_feed_items.id')
  scope :ordered, select('greatest(activity_feed_items.created_at, max(children.created_at)) as order_date').order('order_date desc')
  scope :after, lambda { |date| having("greatest(activity_feed_items.created_at, max(children.created_at)) > ?", date) }
  scope :before, lambda { |date| having("greatest(activity_feed_items.created_at, max(children.created_at)) < ?", date) }

  def self.for_user(user)
    id = user.id
    includes(:children).
    top_level.
    joins_children.
    joins_parent_and_child_mentions.
    select_and_group.
    ordered.
    joins("left outer join followings f1 on f1.followable_id = mentions.mentionable_id and f1.followable_type = mentions.mentionable_type").
    joins("left outer join followings f2 on f2.followable_id = activity_feed_items.creator_id and f2.followable_type = 'User'").
    joins("left outer join players on mentions.mentionable_type = 'Player' and mentions.mentionable_id = players.id").
    where("activity_feed_items.creator_id = ? or children.creator_id = ? or f1.user_id = ? or f2.user_id = ? or (mentions.mentionable_type = 'User' and mentions.mentionable_id = ?) or players.user_id = ?",
          id, id, id, id, id, id)
  end

  def self.for(obj)
    case obj
    when User
      includes(:children).
      top_level.
      joins_children.
      joins_parent_and_child_mentions.
      select_and_group.
      ordered.
      where("activity_feed_items.creator_id = ? OR children.creator_id = ? OR (mentions.mentionable_id = ? and mentions.mentionable_type = 'User')", obj.id, obj.id, obj.id)
    when Game
      includes(:children).
      top_level.
      joins_children.
      select_and_group.
      ordered.
      where("activity_feed_items.game_id = ?", obj.id)
    else
      includes(:children).
      top_level.
      joins_children.
      joins_parent_and_child_mentions.
      select_and_group.
      ordered.
      where(mentions: { mentionable_id: obj.id, mentionable_type: obj.class.base_class.name })
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
