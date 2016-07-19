class YoutubeController < ApplicationController

  before_filter :authenticate

  def download_to_dropbox
    if params[:url].present?
      uri = URI(params[:url])
      if uri.host == 'youtu.be' || uri.path == '/watch'
        @service = YoutubeService.new(params[:url])
        @progress = @service.call
      elsif uri.path == '/playlist'
        puts 'do something with the playlist'
      else
        raise ArgumentError.new("Invalid URL")
      end
    else
      render :status => 404
    end
  end

  def save_to_evernote
    youtube_short_url = params.fetch('url')
    youtube_long_url = ExpandUrlService.lengthen(youtube_short_url)
    youtube_video = YoutubeVideo.new(youtube_long_url)
    ApplicationMailer.send_youtube_digest_to_evernote(youtube_vidoe: youtube_video).deliver_now
    Rails.logger.debug!('OK', context: binding)
    render json: { success: true, sent_at: Time.now }
  rescue StandardError => e
    render json: { success: false, error_message: e.message }
  end

end
