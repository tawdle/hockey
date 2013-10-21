class ActivityFeedItem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :game
  has_many :mentions

  attr_accessible :creator, :target, :message, :game, :game_id

  validates_presence_of :message

  before_create :find_mentions
  after_create :broadcast_changes

  default_scope order("created_at desc")

  def self.for(user)
    joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
      where("creator_id = ? or creator_id in (select target_id from followings where user_id = ?) or mentions.user_id = ?", user.id, user.id, user.id)
  end

  scope :for_game, lambda {|game| where(:game_id => game.id) }

  def avatar_url(version_name = nil)
    creator ?
      creator.avatar_url(version_name) :
      ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end

  def avatar_url_thumbnail
    avatar.url(:thumbnail)
  end

  private

  def find_mentions
    username_matches = message.scan(/\@[a-zA-Z0-9_]*/)
    if username_matches
      usernames = username_matches.uniq.map {|s| s[1..-1] }
      User.where(:name => usernames).each do |user|
        mentions << Mention.new(:user => user)
      end
    end
  end

  def broadcast_changes
    game.send(:broadcast_changes, :with => :activity_feed_items) if game
  end
end
