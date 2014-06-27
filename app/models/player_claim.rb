class PlayerClaim < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :player
  belongs_to :manager, :class_name => "User"
  symbolize :state, :in => [:pending, :approved, :denied]

  validates_presence_of :creator
  validates_presence_of :player
  validates_presence_of :manager, :if => :approved_or_denied?
  validates_uniqueness_of :player_id, :scope => [:creator_id, :state], :if => :new_record?

  after_initialize :initialize_state
  after_create :send_created_email

  attr_accessible :creator, :creator_id, :player, :player_id, :manager, :manager_id, :state

  def self.waiting_for_approval_by(manager)
    PlayerClaim.joins(:player => {:team => :authorizations}).where(:state => :pending, :authorizations => {:user_id => manager.id, :role => :manager })
  end

  def approve!(manager)
    case state
    when :pending
      result = false
      PlayerClaim.transaction do
        update_attributes(:state => :approved, :manager => manager)
        result = player.update_attributes(:user_id => creator.id)
        PlayerClaimMailer.delay.approved(self)
      end
      result
    when :approved
      true
    when :denied
      false
    end
  end

  def deny!(manager)
    case state
    when :pending
      result = false
      PlayerClaim.transaction do
        result = update_attributes(:state => :denied, :manager => manager)
        PlayerClaimMailer.delay.denied(self)
      end
      result
    when :approved
      false
    when :denied
      true
    end
  end

  private

  def approved_or_denied?
    [:approved, :denied].include?(state)
  end

  def send_created_email
    PlayerClaimMailer.delay.created(self) if valid?
  end

  def initialize_state
    self.state ||= :pending
  end
end
