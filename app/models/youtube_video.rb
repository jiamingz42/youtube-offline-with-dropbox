# reload!; v = YoutubeVideo.new('https://www.youtube.com/watch?v=YkBaZLhjsXo'); v.highest_quality_mp4_url
class YoutubeVideo

  VIDEO_DOWNLOAD_URL = 0
  AUDIO_DOWNLOAD_URL = 1

  def initialize(url)
    @video_info = JSON.parse(parse_url(url))
  end

  ['upload_date', 'duration', 'title', 'formats'].each do |field_name|
    define_method field_name do
      video_info[field_name]
    end
  end

  def media_formats(filters = {})
    res = formats
    res = res.select do |f|
      is_included = true
      if filters.present?
        filters.each do |filter_key,filter_value|
          if f[filter_key.to_s] != filter_value
            is_included = false
          end
        end
      end
      is_included
    end
    res.collect! do |f|
      keys = %w(format url ext filesize height width)
      f.select { |k,v| keys.include?(k) }
    end
    res
  end

  def video_id
    video_info['id']
  end

  # @example highest_quality_mp4
  # @example highest_quality_mp4_url
  # @example highest_quality_webm
  # @example highest_quality_webm_url
  #
  ['webm', 'mp4'].each do |ext|
    define_method "highest_quality_#{ext}" do
      media_formats(ext: ext).last
    end
    define_method "highest_quality_#{ext}_url" do
      send("highest_quality_#{ext}")['url']
    end
  end

  # private

  def parse_url(url)
    command = "youtube-dl -J #{url}"
    video_info = `#{command}`
  end

  def video_info
    @video_info
  end

  class << self

    def get_download_url(url, url_type = VIDEO_DOWNLOAD_URL)
      command = "#{youtube_dl_bin} -g #{url}"
      download_urls_string = `#{command}`
      download_urls = download_urls_string.split
      download_urls[url_type]
    end

    private

    def youtube_dl_bin
      'youtube-dl'
    end

  end


end
