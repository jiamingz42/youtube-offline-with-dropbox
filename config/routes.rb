Rails.application.routes.draw do

  mount ResqueWeb::Engine => '/resque_web'

  match 'webhook_reciever/index', :via => [:get, :post]
  get 'youtube/download_to_dropbox'

  get 'job/status/:job_id', to: 'jobs#status'

end
