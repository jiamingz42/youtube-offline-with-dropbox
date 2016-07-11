require File.expand_path('../../config/environment', __FILE__)

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


board = find(TrelloClient.instance.boards, name: 'Study Board (Archived)')

cards = board.lists
             .map { |l| find(l.cards, name: /^Pocket:/) }
             .flatten

label = find(board.labels, name: 'Pocket')

cards.each do |card|
  unless card.labels.include?(label)
    card.add_label(label)
  end
end

