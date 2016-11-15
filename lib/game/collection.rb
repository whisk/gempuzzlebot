require_relative '../game'

class GameCollection
  attr_accessor :games

  def initialize
    @games = {}
  end

  def start(user_id, difficulty)
    @games[user_id] = [] unless @games[user_id]
    id = @games[user_id].size
    @games[user_id] << Game.new(id, 4, difficulty)

    @games[user_id][id]
  end

  def stop(user_id)
    @games[user_id] = []
  end

  def find_by_callback(user_id, callback_data)
    board_id, = callback_data.split('_').map(&:to_i)
    if @games[user_id] && @games[user_id][board_id]
      return @games[user_id][board_id]
    else
      raise GameException, 'Game not found'
    end
  end
end
