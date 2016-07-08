require File.expand_path('../../config/environment', __FILE__)

boards = TrelloClient.instance.boards

board = boards.find { |b| b.name == "Person Study Board" }
card = board.cards.find { |c| c.name == 'Book: Spark' }

checklist_name = 'Reading Progress'
checklist = card.checklists.find { |c| c.name = checklist_name }
unless checklist.present?
  checklist = Trello::Checklist.new(name: checklist_name)
  card.add_checklist(checklist)
end

loop do
  begin
    checklist = card.checklists.find { |c| c.name = checklist_name } # reload
    total_chapter = 10
    (1..total_chapter).each do |chapter_i|
      chapter_i_as_s = "%.#{total_chapter.to_s.length}d" % chapter_i
      checklist.add_item("Chapter #{chapter_i_as_s}")
    end
    break
  rescue Trello::Error => error
    puts error
  end
end
