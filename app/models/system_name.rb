class SystemName < ActiveRecord::Base
  belongs_to :nameable, :polymorphic => true, :inverse_of => :system_name

  NameFormat = "[[:alpha:]\\d\\-_]+"

  strip_attributes

  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A#{NameFormat}\Z/, :message => 'can contain only alphanumeric characters'
  validates_length_of :name, :within => 3..60
  validates_presence_of :nameable
  validates_uniqueness_of :nameable_id, :scope => :nameable_type

  attr_accessible :name, :nameable

  def at_name
    "@#{name}"
  end
end
