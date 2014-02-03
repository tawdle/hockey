class StaffMember < ActiveRecord::Base
  include SoftDelete

  attr_accessible :name, :role
  belongs_to :team
  belongs_to :user # option, after being claimed

  Roles = [:manager, :head_coach, :assistant_coach, :safety_attendant]

  validates_presence_of :name
  validates_presence_of :team
  symbolize :role, :in => Roles

  def name_and_role
    "#{name} (#{I18n.t(role, :scope => 'activerecord.values.staff_member.role')})"
  end
end
