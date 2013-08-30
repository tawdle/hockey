class GoalPlayer < ActiveRecord::Base
  belongs_to :goal
  belongs_to :player
  acts_as_list :column => :ordinal, :scope => :goal, :top_of_list => 0

  validates_presence_of :goal
  validates_presence_of :player
  validates_uniqueness_of :player_id, :scope => :goal_id
end

