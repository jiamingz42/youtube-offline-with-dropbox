class YoutubeDownloader

  def initialize(_youtube_video_url, _download_filename)
    @youtube_video_url = _youtube_video_url
    @download_filename = _download_filename
  end
  def download_to_dropbox
    exec(download_to_dropbox_cmd)
  end

  private

  def download_to_dropbox_cmd
    %{#{dropbox_uploader_bin} saveurl "#{youtube_video_url}" / "#{download_filename}"}
  end
  def exec(cmd)
    `#{cmd}`
  end
  def dropbox_uploader_bin
    './vendor/dropbox_uploader/dropbox_uploader.sh'
  end
  def youtube_video_url
    @youtube_video_url
  end
  def download_filename
    @download_filename
  end

  class << self
    def download_to_dropbox(url, filename)
      new(url, filename).download_to_dropbox
    end
    def test
      self.download_to_dropbox('https://www.youtube.com/watch?v=_1yAOK0nSb0')
    end
  end

end
