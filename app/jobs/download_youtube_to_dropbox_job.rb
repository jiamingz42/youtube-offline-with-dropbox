class DownloadYoutubeToDropboxJob < ActiveJob::Base
  queue_as :urgent

  def perform(url)
    YoutubeDownloader.download_to_dropbox(url)
  end
end
