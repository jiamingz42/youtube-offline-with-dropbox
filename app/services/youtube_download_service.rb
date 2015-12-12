class YoutubeDownloadService

    def initialize(youtube_video_url)
      @youtube_video = YoutubeVideo.new(youtube_video_url)
    end

    def download_url
      @youtube_video.highest_quality_mp4_url
    end

    def call

      @job_id = YoutubeDownloadJobIdCache.get(@youtube_video.video_id)
      if @job_id.nil?
        @job_id = YoutubeDownloadWorker.create(url: download_url)
        @job_id = YoutubeDownloadJobIdCache.set(@youtube_video.video_id, @job_id)
      end

      @status = Resque::Plugins::Status::Hash.get(@job_id) || {}

      ServiceProgress.new(@youtube_video, @status)
    end

end

class ServiceProgress
  def initialize(youtube_video, job_status)
    @youtube_video = youtube_video
    @job_status = job_status
  end
  def video_info
    info = {
      :id          => @youtube_video.video_id,
      :title       => @youtube_video.title,
      :duration    => @youtube_video.duration,
      :description => @youtube_video.description,
    }
  end
  def job_status
    @job_status.select do |k,v|
      %w(time status message).include?(k)
    end
  end
  def as_json
    json = {
      :video_info => video_info,
      :job_status => job_status,
    }
  end
end
