class GameStaffMemberSerializer < ActiveModel::Serializer
  attributes :id, :name, :role, :team_id

  def id
    object.staff_member_id
  end

  def name
    object.staff_member.name
  end

  def team_id
    object.staff_member.team_id
  end
end
