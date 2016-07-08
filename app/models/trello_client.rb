class TrelloClient

  include Singleton

  def initialize
    @myself = Trello::Member.find(ENV['TRELLO_MEMBER_NAME'])
  end

  def boards
    @myself.boards
  end

end
