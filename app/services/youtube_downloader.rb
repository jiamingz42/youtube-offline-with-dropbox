class YoutubeDownloader

  def initialize(url)
    @youtube_video = YoutubeVideo.new(url)
  end
  def download_to_dropbox
    cmd = %{#{dropbox_uploader_bin} saveurl "#{youtube_video_url}" / "#{download_filename}"}
  end
  def dropbox_uploader_bin
    './vendor/dropbox_uploader/dropbox_uploader.sh'
  end
  def youtube_video_url
    @youtube_video.highest_quality_mp4_url
  end
  def download_filename
    @youtube_video.title + '.mp4'
  end

  class << self
    def download_to_dropbox(url)
      new(url).download_to_dropbox
    end
    def test
      self.download_to_dropbox('https://www.youtube.com/watch?v=_1yAOK0nSb0')
    end
  end

end
