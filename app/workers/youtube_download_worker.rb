class YoutubeDownloadWorker < Worker

  @queue = :normal

  def perform
    set_status({
      dropbox_save_url_job: dropbox_service.save_url(
        youtube_video.save_path, youtube_video.download_url)
    })
  end

  def youtube_video
    if @youtube_video.nil?
      @youtube_video = YoutubeVideo.new(options['youtube_video_url'])
      set_status({
          :video_info => {
            :video_id    => youtube_video.video_id,
            :upload_date => youtube_video.upload_date,
            :duration    => youtube_video.duration,
            :title       => youtube_video.title,
            :description => youtube_video.description,
          }
      })
    end
    @youtube_video
  end
  private :youtube_video

  def dropbox_service
    @dropbox_service ||= DropboxService.new(ENV['DROPBOX_ACCESS_TOKEN'])
  end
  private :dropbox_service

end
