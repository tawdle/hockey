namespace :videos do
  task :import => :environment do
    # Iterate over files in video-inbox
    s3 = AWS::S3.new
    bucket = s3.buckets['bigshot-' + Rails.env]
    bucket.objects.with_prefix("video-inbox/").each do |object|
      match = object.key.match(/goal-(\d+)-/)
      unless match && match[1]
        puts "Error: couldn't extract goal_id from key #{object.key}"
        next
      end
      goal_id = match[1].to_i
      goal = Goal.find_by_id(goal_id)
      unless goal
        puts "Error: couldn't find goal with ID=#{goal_id}"
        next
      end
      feed_item = Feed::NewGoal.unscoped.where(:game_id => goal.game_id).order("abs(extract(epoch from('#{goal.created_at}'::timestamp - created_at)))").first
      unless feed_item
        puts "Error: couldn't find related feed item for goal ID=#{goal_id}"
        next
      end

      thumb_key = object.key.sub("video-inbox", "thumbs").sub(/\.(mp4|mov)$/, ".png")
      unless bucket.objects[thumb_key].exists?
        puts "Error: couldn't find matching thumbnail '#{thumb_key}'"
        next
      end
      new_key = object.key.sub("video-inbox", "videos")
      video = Video.create(:file_key => new_key, :thumb_key => thumb_key, :goal_id => goal_id, :feed_item_id => feed_item.id)
      unless video
        puts "Error: failed to create video object: #{video.errors}"
        next
      end
      object.move_to(new_key)
    end
  end
end
