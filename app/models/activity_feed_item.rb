class ActivityFeedItem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :game, :inverse_of => :activity_feed_items
  has_many :mentions

  attr_accessible :creator, :message, :game, :game_id

  validates_presence_of :message

  before_create :find_mentions
  after_create :broadcast_changes

  default_scope order("created_at desc")

  UserIdsForFollowedUsers = "SELECT system_names.nameable_id
                             FROM followings
                             JOIN system_names ON followings.system_name_id = system_names.id
                             WHERE followings.user_id = ? AND system_names.nameable_type = 'User'"

  def self.for(obj)
    system_name = obj.system_name
    if obj.is_a?(User)
      joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
        where("creator_id = ? OR creator_id IN (#{UserIdsForFollowedUsers}) OR mentions.system_name_id = ?",
              obj.id, obj.id, system_name.id)
    else
      joins('LEFT OUTER JOIN mentions on activity_feed_items.id = mentions.activity_feed_item_id').
        where("mentions.system_name_id = ?", system_name.id)
    end
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
    username_matches = message.scan(/\@#{SystemName::NameFormat}/)
    if username_matches
      usernames = username_matches.uniq.map {|s| s[1..-1] }
      SystemName.where(:name => usernames).each do |sn|
        mentions << Mention.new(:system_name => sn)
      end
    end
  end

  def broadcast_changes
    game.send(:broadcast_changes, :with => [:activity_feed_items]) if game
  end
end
