class PenaltySerializer < ActiveModel::Serializer
  attributes :id, :category, :infraction, :minutes, :period, :elapsed_time, :player_id,
    :serving_player_id, :state
  has_one :timer
end
