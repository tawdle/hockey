class TeamClaim < ActiveRecord::Base
  belongs_to :team
  attr_accessible :team, :team_id

  validates_presence_of :team

  before_create :set_code

  def set_code
    self.code = RandomToken.generate
  end
end
