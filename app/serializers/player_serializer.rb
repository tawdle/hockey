class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :team_id, :jersey_number, :at_name, :name_and_number
end
