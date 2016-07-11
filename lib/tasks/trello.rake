require 'trello'

task :update_pocket_unread_article_count => :environment do

  Trello.configure do |config|
    config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
    config.member_token = ENV['TRELLO_MEMBER_TOKEN']
  end

  me = Trello::Member::find(ENV['TRELLO_MEMBER_NAME'])

  board = me.boards.find { |b| b.name == "Study Board" }
  list = board.lists.find { |l| l.name == 'Backlog' }

  card = list.cards.find { |c| c.id == '574d003637bb63d07c3095e2' }

  pocket_client = Pocket::Client.new(
    access_token: ENV['POCKET_ACCESS_TOKEN'],
    consumer_key: ENV['POCKET_CONSUMER_KEY']
  )
  unread_items = pocket_client.retrieve({state: 'unread'})['list'].values
  unread_article_count = unread_items.size

  card.name = "Pocket: #{unread_article_count} Unread Items"
  card.desc = <<-EOS
#{unread_items.select { |v| v['is_article'] == '1' }.size} items are article
#{unread_items.select { |v| /pdf/.match v['given_url'] }.size} items are PDF
#{unread_items.select { |v| v['has_video'] != '0' }.size} items contains video(s)
  EOS
  card.save

end

task :auto_attach_label => :environment do

  def find(array, options = {})
    new_array = options.inject(array) do |acc, (key, matcher)|
      acc.select do |item| 
        value = item.send(key)
        if matcher.class == Regexp
          matcher.match(value)
        else
          matcher == value
        end
      end
    end
    new_array.first
  end

  ['Study Board', 'Study Board (Archived)'].each do |board_name|

    board = find(TrelloClient.instance.boards, name: board_name)

    course_label = find(board.labels, name: 'Course')
    book_label = find(board.labels, name: 'Book')

    board.lists.each do |list|
      list.cards.each do |card|
        if /^\u{1F3DB}/.match(card.name)
          unless card.labels.include?(course_label)
            card.add_label(course_label)
          end
        elsif /^[📕📘📗📓]/.match(card.name)
          unless card.labels.include?(book_label)
            card.add_label(book_label)
          end
        end
      end
    end
  end

end
