require File.expand_path('../../config/environment', __FILE__)

boards = TrelloClient.instance.boards

boards.each_with_index do |board, index|
  puts "[#{index}] #{board.name}"
end
print "Select board: "
board = boards[gets.to_i]
puts 

lists = board.lists
lists.each_with_index do |list, index|
  puts "[#{index}] #{list.name}"
end
print "Select list: "
list = lists[gets.to_i]
puts

cards = list.cards
selected_cards = cards.select do |card|
  /Pocket:/i.match(card.name)
end

extracted_data_list = []

selected_cards.each do |c|

  extracted_data = {}

  desc = c.desc.gsub(/^Tags:.*\n/, '')

  regex_for_article_url = 
    %r{^via Pocket (http[s]?://.*)\n}
  
  if match_data_for_article_url = regex_for_article_url.match(desc)
    extracted_data[:article_url] = ExpandUrlService.lengthen(match_data_for_article_url[1])
    desc = desc.gsub(regex_for_article_url, '')
  end
  
  regex_for_added_at_date_and_img_url = 
    %r{^(\w{1,} \d{2}, \d{4} at \d{2}:\d{2}(AM|PM)) (http[s]?://.*)$}
  if match_data_for_added_at_date_and_img_url = regex_for_added_at_date_and_img_url.match(desc)
    extracted_data[:added_at] = match_data_for_added_at_date_and_img_url[1]
    extracted_data[:img_url] = ExpandUrlService.lengthen(match_data_for_added_at_date_and_img_url[3])
    desc = desc.gsub(regex_for_added_at_date_and_img_url, '')
  end

  lines = desc.split("\n").map(&:chomp)
  if lines.size == 1
    extracted_data[:title] == lines.first
  elsif lines.size == 2
    extracted_data[:title], extracted_data[:description] = lines
  else
    raise StandardError
  end

  extracted_data_list << extracted_data
end

description = extracted_data_list
  .map do |extracted_data|
    desc = ""
    desc += "#{extracted_data[:added_at]} [Link](#{extracted_data[:article_url]})\n"
    desc += "**#{extracted_data[:title]}**\n\n"
    desc += "#{extracted_data[:description]}\n\n" if extracted_data[:description]
    desc += "![](#{extracted_data[:img_url].gsub(/http:/, 'https:')})\n\n" if extracted_data[:img_url]
    desc
  end
  .join("------\n\n")

puts description

# Trello::Card.create(name: "Pocket Items #{extracted_data_list.size}", idList: list.name, desc: description)