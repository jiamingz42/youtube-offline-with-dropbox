class WebhookRecieverController < ApplicationController

  before_filter :show_params

  def slack
    render :text => params
  end

  def email
    # sender  = params['headers']['Sender']
    # subject = params['headers']['Subject']
    body    = params['plain']

    # if sender == 'benjamin19890721@gmail.com'
      # find the URL and expand the it
      regex = /(http:\/\/youtu\.be\/.*)/
      match = regex.match(body)
      if match.nil?
        render :text => 'No Match'
      else
        youtube_short_url = match[0]
        youtube_long_url = ExpandUrlService.lengthen(youtube_short_url)
        ApplicationMailer.send_mail({
          subject: 'Youtube Video URL',
          youtube_long_url: youtube_long_url}
          ).deliver
        render :text => 'OK'
      end
    # else
      # render :status => 500
    # end
  end

private

    def show_params
      Rails.logger.info!('params => ', obj: params, context: binding)
    end


end
