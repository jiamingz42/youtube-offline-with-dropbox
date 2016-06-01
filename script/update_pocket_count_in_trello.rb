require File.expand_path('../../config/environment', __FILE__)
require 'trello'

# https://github.com/jeremytregunna/ruby-trello

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  config.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

me = Trello::Member::find(ENV['TRELLO_MEMBER_NAME'])

board = me.boards.find { |b| b.name == "Study Board" }
list = board.lists.find { |l| l.name == 'Backlog' }

card = list.cards.find { |c| c.id == '574d003637bb63d07c3095e2' }

card.name = "Pocket: #{42} Unread Article"
card.save
