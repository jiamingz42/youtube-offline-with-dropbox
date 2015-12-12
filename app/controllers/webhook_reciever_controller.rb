class WebhookRecieverController < ApplicationController
  def index
    Rails.logger.debug!('Recieve webhook ....', :obj => params, :context => binding)
    render :text => :success
  end
end
