class YoutubeDownloadService

    # @param [String]
    #   @example https://www.youtube.com/watch?v=MNrZKiamgIw
    def initialize(youtube_video_url)
      @youtube_video_url = youtube_video_url.strip
    end

    def youtube_video_url
      @youtube_video_url
    end

    # @todo restart failed job
    def call
      @job_id = cache.get_or_set_if_not_existed("YoutubeDownloadService:#{youtube_video_url}", expire_after: 60*60*24) do
        YoutubeDownloadWorker.create(youtube_video_url: youtube_video_url)
      end
      job_status
    end

    def cache
      Cache
    end
    private :cache

    def dropbox_service
      @dropbox_service ||= DropboxService.new(ENV['DROPBOX_ACCESS_TOKEN'])
    end
    private :dropbox_service

    def job_status
      status = Resque::Plugins::Status::Hash.get(@job_id) || {}
      dropbox_save_url_job = status.fetch('dropbox_save_url_job',{})
      if dropbox_save_url_job['status'] != 'COMPLETE' && dropbox_save_url_job['job'].present?
        dropbox_save_url_job.merge!(dropbox_service.save_url_job(dropbox_save_url_job['job']))
      end
      status
    end
    private :job_status

end
