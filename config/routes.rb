Rails.application.routes.draw do

  mount ResqueWeb::Engine => '/resque_web'

  match 'webhook_reciever/index', :via => [:get, :post]
  get 'youtube/download_to_dropbox'

end
