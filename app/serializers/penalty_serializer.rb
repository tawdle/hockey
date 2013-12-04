class PenaltySerializer < ActiveModel::Serializer
  attributes :id, :category, :infraction, :minutes, :period, :elapsed_time, :team_id,
    :penalizable_type_and_id, :penalizable_type, :penalizable_id, :serving_player_id, :state
  has_one :timer
end
