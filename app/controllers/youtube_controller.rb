class YoutubeController < ApplicationController
  # GET http://localhost:1557/youtube/download_to_dropbox?url=https://www.youtube.com/watch?v=MNrZKiamgIw
  def download_to_dropbox
    if params[:url].present?
      render :text => YoutubeDownloader.download_to_dropbox(params[:url])
    else
      render :status => 404
    end
  end
end
