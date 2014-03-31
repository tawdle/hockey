class Video < ActiveRecord::Base
  include SoftDelete

  belongs_to :feed_item, :class_name => "ActivityFeedItem"
  belongs_to :goal

  validates_presence_of :feed_item
  validates_presence_of :goal
  validates_presence_of :file_key
  validates_presence_of :thumb_key

  attr_accessible :file_key, :thumb_key, :goal_id, :feed_item_id

  def thumb_url
    bucket.objects[thumb_key].public_url.to_s
  end

  def secure_url
    CloudFront.get_signed_expiring_url("https://#{ENV['AWS_CLOUDFRONT_DOMAIN']}/#{file_key}", 60.seconds)
  end

  def file_url
    bucket.objects[file_key].url_for(:read, :expires => 10.minutes).to_s
  end

  def poster_url
    bucket.objects[poster_key].public_url.to_s
  end

  def file_height
    file_width * 9 / 16
  end

  def file_width
    960
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
