class WebhookRecieverController < ApplicationController

  def slack
    render :text => params
  end

  def email
    ap params
    render :json => params
  end
end
