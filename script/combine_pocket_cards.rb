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

print "Select [1] Pocket or [2] Wunderlist: "

if gets.to_i == 1

  selected_cards = cards.select do |card|
    /Pocket:/i.match(card.name)
  end

  extracted_data_list = []

  selected_cards.each do |c|

    extracted_data = {}

    desc = c.desc

    # `begin` block keep variables `regex` and `match_data` local
    desc = begin 
      regex = %r{^\*\*\[(?<title>.*)\]\((?<article_url>.*)\)\*\*$}  
      if match_data = regex.match(desc)
        extracted_data[:title] = match_data['title']
        extracted_data[:article_url] = ExpandUrlService.lengthen(match_data['article_url'])
        desc.sub(regex, '')
      else
        desc
      end
    end
    
    desc = begin
      regex = %r{^- (\w{1,} \d{2}, \d{4} at \d{2}:\d{2}(AM|PM))$}
      if match_data = regex.match(desc)
        extracted_data[:added_at] = match_data[1]
        # extracted_data[:img_url] = ExpandUrlService.lengthen(match_data_for_added_at_date_and_img_url[3])
        # extracted_data[:img_url] = nil if /no_image_card.png/.match(extracted_data[:img_url])
        desc.sub(regex, '')
      else
        desc
      end
    end

    desc = begin
      regex = %r{^!\[.*\]\((.*)\)$}
      if match_data = regex.match(desc)
        extracted_data[:img_url] = ExpandUrlService.lengthen(match_data[1])
        extracted_data[:img_url] = nil if /no_image_card.png/.match(extracted_data[:img_url])
        desc.sub(regex, '')
      else
        desc
      end    
    end

    lines = desc.split("\n").reject(&:blank?).map(&:chomp)
    if lines.size == 1
      extracted_data[:description] = lines.first.sub(/^- /, '').sub(/$/, ' ...')
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

  puts "Pocket Items (#{extracted_data_list.size})\n\n"

  puts description

else

  selected_cards = cards.select do |card|
    /^Wunderlist:/i.match(card.name)
  end

  puts "Miscellaneous (#{selected_cards.size})\n\n"

  description = selected_cards.map do |card|
    task_name = /^Wunderlist:[ ]?(.*)/.match(card.name)[1]
    complated_at = /Completed at[ ]?(.*)/.match(card.desc)[1]
    "0. #{task_name}\n   #{complated_at}"
  end

  puts description

end