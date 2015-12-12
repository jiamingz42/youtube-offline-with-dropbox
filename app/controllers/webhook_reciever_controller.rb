class WebhookRecieverController < ApplicationController
  def index
    Rails.logger.info!('Recieve webhook ....', :obj => params, :context => binding)
    render :text => :success
  end
end
