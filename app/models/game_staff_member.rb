class GameStaffMember < ActiveRecord::Base
  belongs_to :game
  belongs_to :staff_member
  symbolize :role, :in => StaffMember::Roles

  validates_presence_of :game
  validates_presence_of :staff_member
  validate :staff_member_is_on_team

  attr_accessible :game, :staff_member_id, :staff_member, :role

  default_scope order(StaffMember::Roles.map {|role| "game_staff_members.role != '#{role}'"}.join(","))
  scope :for_team, lambda {|team| joins(:staff_member).where(:staff_members => {:team_id => team.id }) }

  private

  def staff_member_is_on_team
    errors.add(:staff_member, "must be associated with home or visiting team") if game && staff_member && !game.teams.include?(staff_member.team)
  end
end
