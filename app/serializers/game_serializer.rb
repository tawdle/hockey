class GameSerializer < ActiveModel::Serializer
  attributes :id, :state, :home_team, :visiting_team, :period_text, :period
  has_one :clock
  has_many :players
  has_many :goals
  has_many :penalties
  has_many :activity_feed_items

  def home_team
    { :score => object.home_team_score, :id => object.home_team_id, :goalie_id => object.current_goalie_id_for(object.home_team) }
  end

  def visiting_team
    { :score => object.visiting_team_score, :id => object.visiting_team_id, :goalie_id => object.current_goalie_id_for(object.visiting_team) }
  end

  def include_clock?
    true
  end

  [:players, :goals, :penalties, :activity_feed_items].each do |association|
    define_method "include_#{association}?" do
      Array(options[:with]).include?(association)
    end
  end

  def attributes
    # active_model_serializer doesn't allow us to :include attributes that aren't
    # statically specified above, so we add in any that were requested by the caller
    # but didn't get added by the super call.

    data = super
    Array(options[:methods]).each do |attr|
      data[attr] = object.send(attr) unless data.key?(attr)
    end
    data
  end
end
