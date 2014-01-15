class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :team_id, :jersey_number, :name, :at_name, :name_and_number, :role, :photo_url
end
