class TimerSerializer < ActiveModel::Serializer
  attributes :id, :state, :elapsed_time, :duration
end
