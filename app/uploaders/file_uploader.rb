# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
end
