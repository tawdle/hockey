class StaffMember < ActiveRecord::Base
  attr_accessible :name, :role
  belongs_to :team
  belongs_to :user # option, after being claimed

  Roles = [:head_coach, :assistant_coach, :manager, :safety_attendant]

  validates_presence_of :name
  validates_presence_of :team
  symbolize :role, :in => Roles
end
