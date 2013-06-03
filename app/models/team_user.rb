class TeamUser < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  # attr_accessible :title, :body
end
