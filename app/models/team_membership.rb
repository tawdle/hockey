class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :member, :class_name => 'User'
  attr_accessible :team, :team_id, :member, :member_id

  validates_presence_of :team
  validates_presence_of :member
  validates_uniqueness_of [:team_id, :member_id]
end