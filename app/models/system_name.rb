class SystemName < ActiveRecord::Base
  belongs_to :nameable, :polymorphic => true

  NameFormat = "[[:alpha:]\\d\\-_]+"

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A#{NameFormat}\Z/, :message => 'can contain only alphanumeric characters'
  validates_length_of :name, :within => 3..20
  validates_presence_of :nameable
  validates_uniqueness_of :nameable_id, :scope => :nameable_type

  attr_accessible :name
end