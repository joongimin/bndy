class PhotosController < ApplicationController
  def index
    @photos_count = 26
    @photo_index = params[:photo_index].to_i
  end
end
