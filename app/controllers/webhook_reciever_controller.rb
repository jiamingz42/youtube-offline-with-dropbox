class WebhookRecieverController < ApplicationController

  def slack
    render :text => params
  end

  def email
    render :json => params
  end
end
