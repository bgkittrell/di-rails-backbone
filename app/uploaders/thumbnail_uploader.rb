# encoding: utf-8

class ThumbnailUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  process :resize_to_fill => [400, 400]
end
