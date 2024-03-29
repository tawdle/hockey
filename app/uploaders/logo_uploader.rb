# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def public_id
    [Rails.env.production? ? nil : Rails.env, mounted_as, model.class.name, model.id.to_s].compact.join("-").downcase
  end

  process :convert => 'png'

  version :thumbnail do
    resize_to_fit(75, 75)
    cloudinary_transformation :radius => 5
  end

  version :small do
    resize_to_fit(100, 100)
    cloudinary_transformation :radius => 5
  end

  version :medium do
    resize_to_fit(300, 300)
    cloudinary_transformation :radius => 5
  end

  version :large do
    resize_to_fit(200, 200)
    cloudinary_transformation :radius => 5
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + ["logo", version_name].compact.join('_') + ".png")
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
