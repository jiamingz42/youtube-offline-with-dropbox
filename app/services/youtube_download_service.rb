class YoutubeDownloadService

    def initialize(youtube_video_url)
      @youtube_video = YoutubeVideo.new(youtube_video_url)
    end

    def call
      # @job_id = YoutubeDownloadWorker.create
      @youtube_video.title
    end

end
