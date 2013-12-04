class PenaltySerializer < ActiveModel::Serializer
  attributes :id, :category, :infraction, :minutes, :period, :elapsed_time,
    :penalizable_type_and_id, :serving_player_id, :state
  has_one :timer
end
