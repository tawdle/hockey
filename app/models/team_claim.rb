class TeamClaim < ActiveRecord::Base
  belongs_to :team
  attr_accessible :team, :team_id

  validates_presence_of :team

  before_create :set_code

  require 'securerandom'

  def set_code
    self.code = Digest::SHA1.hexdigest(SecureRandom.random_bytes(32))
  end
end
