class ExpandUrlService

  def initialize
  end

  def lengthen(url)
    uri = URI(url)
    Net::HTTP.new(uri.host, 80).get(uri.path).header['location']
  end

  class << self
    def lengthen(url)
      new.lengthen(url)
    end
  end

end
