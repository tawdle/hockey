class Tournament < League
  has_and_belongs_to_many :teams

  attr_accessible :team_ids

  def eligible_leagues
    League.where(:division => division, :classification => classification).where("id <> ?", id)
  end

  def start_date
    games.minimum(:start_time).try(:to_date)
  end

  def end_date
    games.maximum(:start_time).try(:to_date)
  end

  def locations
    Location.joins(:games).where(:games => {:league_id => id }).select('distinct "locations".*')
  end
end
