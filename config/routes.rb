Rails.application.routes.draw do

  match 'dropbox/save_url', :via => [:get, :post]

  mount ResqueWeb::Engine => '/resque_web'

  match 'webhook_reciever/slack', :via => [:get, :post]
  match 'webhook_reciever/email', :via => [:get, :post]

  get 'youtube/download_to_dropbox'

  get 'job/status/:job_id', to: 'jobs#status'

end
