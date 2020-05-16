class ImageUploader < CarrierWave::Uploader::Base
  if Rails.env.production?
    include Cloudinary::CarrierWave

    process tags: ['post_image']

    version :standard do
      process resize_to_fill: [100, 150, :north]
    end

    version :thumbnail do
      resize_to_fit(50, 50)
    end
  else
    include CarrierWave::MiniMagick
    storage :file

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  version :thumb do
    process resize_to_fit: [150, 150]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
