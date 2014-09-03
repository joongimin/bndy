class PhotosController < ApplicationController
  def index
    @photo_index = params[:photo_index]
  end
end
