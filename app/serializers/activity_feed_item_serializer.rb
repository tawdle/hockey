class ActivityFeedItemSerializer < ActiveModel::Serializer
  attributes :id, :avatar_thumbnail_url, :creator, :message, :created_at
  has_many :videos

  def avatar_thumbnail_url
    object.avatar_url(:thumbnail)
  end

  def created_at
    object.created_at.iso8601
  end

  def message
    ActionView::Base.new(Rails.configuration.paths["app/views"].first + "/application").render(
      :partial => 'activity_feed_item', :format => :html,
      :locals => { :item => object }
    )
  end

  def creator
    object.creator.try(:name) if object.respond_to?(:creator)
  end
end
