class Feed::UserPost < ActivityFeedItem
  belongs_to :creator, :class_name => "User"

  attr_accessor :target_type, :target_id

  attr_accessible :creator_id, :creator, :message, :target_type, :target_id

  TargetClasses = [User, Tournament, League, Location, Player, Team]
  validates_presence_of :creator
  validates_presence_of :message
  validates_inclusion_of :target_type, :in => TargetClasses.map(&:to_s), :allow_nil => true

  def avatar_url(version_name = nil)
   creator.avatar_url(version_name)
  end

  private

  def mentioned_objects
    res = []
    username_matches = message.scan(Mention::NameOrPlayerPattern)
    usernames = username_matches.flatten.uniq
    usernames.each do |username|
      if username.include?("#")
        team_name, jersey_number = username.split("#")
        if team = Team.find_by_at_name(team_name)
          if player = Player.find_by_jersey_number_and_team_id(jersey_number, team.id)
            res << player
          end
        end
      else
        sn = SystemName.find_by_name(username)
        res << sn.nameable if sn
      end
    end
    if target_type && target_id
      target = target_type.constantize.find(target_id)
      res << target unless res.include?(target)
    end
    res
  end
end
