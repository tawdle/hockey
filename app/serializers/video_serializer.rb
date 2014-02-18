class VideoSerializer < ActiveModel::Serializer
  attributes :thumb_url, :show_url

  def show_url
    video_path(object)
  end
end

