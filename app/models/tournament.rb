class Tournament < League
  has_and_belongs_to_many :teams

  attr_accessible :team_ids

  def eligible_leagues
    League.where(:division => division, :classification => classification).where("id <> ?", id)
  end
end
