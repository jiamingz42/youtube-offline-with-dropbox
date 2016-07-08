require File.expand_path('../../config/environment', __FILE__)

card = TrelloClient.instance
                   .boards
                   .find { |b| b.name == 'Study Board' }
                   .lists
                   .find { |l| l.name == 'Active Project' }
                   .cards
                   .find { |c| c.name == 'Read Uber Engineer Blog' }

checklist = card.checklists.first

page = HTTParty.get("http://eng.uber.com/")
pp = Nokogiri::XML.parse(page)

pp.css(".post .post_link a")
  .reverse
  .each do |item|
    title = item.text.strip
    url = BitlyClient.instance.shorten(item['href']).short_url
    checklist.add_item("#{title} #{url}")
  end

#
