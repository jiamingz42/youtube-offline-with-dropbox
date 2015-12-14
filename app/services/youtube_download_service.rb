class YoutubeDownloadService

    # @param [String]
    #   @example https://www.youtube.com/watch?v=MNrZKiamgIw
    def initialize(youtube_video_url)
      @youtube_video_url = youtube_video_url.strip
    end

    def youtube_video_url
      @youtube_video_url
    end

    def call
      @job_id = cache.get_or_set_if_not_existed("YoutubeDownloadService:#{youtube_video_url}", expire_after: 60*60*24) do
        YoutubeDownloadWorker.create(youtube_video_url: youtube_video_url)
      end
      @status = Resque::Plugins::Status::Hash.get(@job_id) || {}
    end

    def cache
      Cache
    end
    private :cache

end
