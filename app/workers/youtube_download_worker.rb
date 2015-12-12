class YoutubeDownloadWorker < Worker
  @queue = :normal
  def perform
    YoutubeDownloader.download_to_dropbox options['url']
  end
end
