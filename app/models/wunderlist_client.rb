class WunderlistClient

  def client
    self.class.client
  end

  def get_list(list_name)
    client.list(list_name)
  end

  class << self
    def client
      @client ||= Wunderlist::API.new({
        :access_token => ENV['WUNDERLIST_ACCESS_TOKEN'],
        :client_id => ENV['WUNDERLIST_CLIENT_ID']
      })
    end
  end
end
