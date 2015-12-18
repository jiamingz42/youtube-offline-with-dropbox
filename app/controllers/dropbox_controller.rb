class DropboxController < ApplicationController
  def save_url
    if [:url, :path].all? { |f| params[f].present? }
      @dropbox_service = DropboxService.new(ENV['DROPBOX_ACCESS_TOKEN'])
      render :json => @dropbox_service.save_url(params[:path], params[:url])
    else
      render :status => 500
    end
  end
end
