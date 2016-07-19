class PocketController < ApplicationController
  def random_unread_article
    unread_article_count = Cache.get('unread_article_count').to_i
    if unread_article_count.nil? || unread_article_count == 0
      unread_items = pocket_client.retrieve(state: 'unread')['list'].values
      unread_article_count = unread_items.size
      Cache.set('unread_article_count', unread_article_count, expire_after: 60 * 60)
    end
    resp = pocket_client.retrieve(state: 'unread', count: 1, offset: rand(unread_article_count + 1))
    render json: resp['list'].values.first
  end

  private

  def pocket_client
    @pocket_client ||= begin
      Pocket::Client.new(
        access_token: ENV['POCKET_ACCESS_TOKEN'],
        consumer_key: ENV['POCKET_CONSUMER_KEY']
      )
    end
  end
end
