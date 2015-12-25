class WebhookRecieverController < ApplicationController

  def slack
    render :text => params
  end

  def email
    sender  = params['headers']['Sender']
    subject = params['headers']['Subject']
    body    = params['plain']

    # if sender == 'benjamin19890721@gmail.com'
      # find the URL and expand the it
      regex = /(http:\/\/youtu\.be\/.*)/
      match = regex.match(body)
      if match.nil?
        render :status => 500
      else
        youtube_short_url = match[0]
        youtube_long_url = ExpandUrlService.lengthen(youtube_short_url)
        ApplicationMailer.send({
          subject: 'Youtube Video URL',
          youtube_long_url: youtube_long_url}
          ).deliver
        render :text => :ok
      end
    # else
    #   render :status => 500
    # end
  end
end
