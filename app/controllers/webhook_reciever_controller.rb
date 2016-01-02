class WebhookRecieverController < ApplicationController

  before_filter :show_params

  def slack
    render :text => params
  end

  def email
    message = CloudMailinMessage.create_from_params(params)

    if message.sender.match(/benjamin19890721@gmail.com/).nil?
      Logger.rails.logger('message.sender is not benjamin19890721@gmail',
        obj: message.sender, context: binding)
      render :status => 500 and return
    end

    if message.subject_match?(/Youtube Video/)
      regex = /(http[s]?:\/\/youtu\.be\/.*)/
      match = regex.match(message.plain_body)
      if match.nil?
        Rails.logger.debug!('No Match', context: binding)
        render :text => 'No Match' and return
      else
        youtube_short_url = match[0]
        youtube_long_url = ExpandUrlService.lengthen(youtube_short_url)
        Rails.logger.debug!('youtube_long_url =>', obj: youtube_long_url, context: binding)
        youtube_vidoe = YoutubeVideo.new(youtube_long_url)
        if message.subject_match?(/Save Watch Later Youtube Video to Dropbox/)
          @service = YoutubeService.new(youtube_long_url)
          @progress = @service.call
          render :json => @progress and return
        elsif message.subject_match?(/Save Liked Youtube Video to Evernote/)
          ApplicationMailer.send_youtube_digest_to_evernote({
            subject: 'Youtube Video URL',
            youtube_vidoe: youtube_vidoe }
            ).deliver_now
          Rails.logger.debug!('OK', context: binding)
          render :text => 'OK' and return
        end
      end
    end

    Rails.logger.debug!('Not sure how to hanlde this message', context: binding)
    render :status => 500

  end

private

    def show_params
      ap params
    end


end
