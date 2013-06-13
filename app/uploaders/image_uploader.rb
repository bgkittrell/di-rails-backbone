# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_limit => [1920, 1080], :if => :is_image?

  def is_image? file
    file.extension =~ /(jpg|jpeg|png)/i
  end
end
