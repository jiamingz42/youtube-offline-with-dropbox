class YoutubeDownloadWorker < Worker
  @queue = :normal
  def perform
    puts 'YoutubeDownloadWorker working ....'
  end
end
