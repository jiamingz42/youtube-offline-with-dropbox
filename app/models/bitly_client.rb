class BitlyClient
  include Singleton
  extend Forwardable
  def_delegators :@bitly, :shorten

  def initialize
    @bitly = Bitly.new(ENV['BITLY_USER_NAME'], ENV['BITLY_API_KEY'])
  end
end
