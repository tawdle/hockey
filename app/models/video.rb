class Video < ActiveRecord::Base
  belongs_to :feed_item, :class_name => "ActivityFeedItem"
  belongs_to :goal

  validates_presence_of :feed_item
  validates_presence_of :goal
  validates_presence_of :file_key
  validates_presence_of :thumb_key

  attr_accessible :file_key, :thumb_key, :goal_id, :feed_item_id

  def thumb_url
    bucket.objects[thumb_key].public_url
  end

  def file_url
    bucket.objects[file_key].url_for(:read, :expires => 10.minutes)
  end

  private

  @s3 = AWS::S3.new

  class << self
    attr_accessor :s3
  end

  def s3
    self.class.s3
  end

  def bucket
    s3.buckets['bigshot-' + Rails.env]
  end
end
