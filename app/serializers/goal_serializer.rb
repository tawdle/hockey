class GoalSerializer < ActiveModel::Serializer
  attributes :id, :team_id, :elapsed_time, :period, :player_ids
end
