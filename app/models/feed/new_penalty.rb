class Feed::NewPenalty < ActivityFeedItem
  belongs_to :player

  attr_accessible :game, :player, :penalty

  validates_presence_of :player
  validates_presence_of :game

  def penalty=(penalty)
    @penalty = penalty
    self.target_name = penalty.infraction
  end

  def penalty
    @penalty
  end

  def message
    I18n.t "feed.new_penalty", player: player.feed_name, penalty: I18n.t("penalties.infractions.#{target_name}")
  end

  def mentioned_objects
    [player]
  end
end




