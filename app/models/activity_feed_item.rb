class ActivityFeedItem < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :game, :inverse_of => :activity_feed_items
  has_many :mentions, :dependent => :destroy, :inverse_of => :activity_feed_item

  attr_accessible :creator, :message, :game, :game_id

  validates_presence_of :message

  before_create :find_mentions
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
    username_matches = message.scan(Mention::NameOrPlayerPattern)
    usernames = username_matches.flatten.uniq
    usernames.each do |username|
      if username.include?("#")
        team_name, jersey_number = username.split("#")
        if team = Team.find_by_at_name(team_name)
          if player = Player.find_by_jersey_number_and_team_id(jersey_number, team.id)
            mentions << Mention.new(mentionable: player)
          end
        end
      else
        sn = SystemName.find_by_name(username)
        mentions << Mention.new(:mentionable => sn.nameable) if sn
      end
    end
  end

  def broadcast_changes
    game.send(:broadcast_changes, :with => [:activity_feed_items]) if game
  end
end
