class YoutubeController < ApplicationController

  before_filter :authenticate

  def download_to_dropbox
    if params[:url].present?
      uri = URI(params[:url])
      case uri.path
      when '/watch'
        @service = YoutubeDownloadService.new(params[:url])
        @progress = @service.call
      when '/playlist'
        puts 'do something with the playlist'
      else
        raise ArgumentError.new("Invalid URL")
      end
    else
      render :status => 404
    end
  end
  private

  def authenticate
    if params[:service_key] != ENV['MY_SERVICE_KEY']
      render :text => 'Unauthorized user'
    end
  end
end
