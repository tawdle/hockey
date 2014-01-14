class GoalSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :team_id, :elapsed_time, :period, :player_ids, :advantage
end
