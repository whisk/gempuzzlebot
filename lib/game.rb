require 'telegram/bot'
require_relative 'board'
require_relative 'game/exception'

class Game
  DEFAULT_DIFF = 9
  attr_accessor :id, :msg_id, :chat_id, :size, :board

  def initialize(id, size, diff = nil)
    @id = id
    @size = size
    diff = DEFAULT_DIFF if diff.nil? || diff == 0
    @board = Board.new(size, diff)
  end

  def attach(sent_message)
    raise GameException, 'Unable to attach game' unless sent_message['ok']
    @msg_id = sent_message['result']['message_id']
    @chat_id = sent_message['result']['chat']['id']
  end

  def move_by_callback(callback_data)
    _, button_id = callback_data.split('_').map(&:to_i)
    @board.move((button_id / @size).to_i, button_id % @size)
  end

  def victory?
    @board.victory?
  end

  def markup
    button_id = 0
    kb = @board.board.map do |row|
      row.map do |x|
        label = x.nil? ? ' ' : x.to_s
        b = Telegram::Bot::Types::InlineKeyboardButton.new(text: label, callback_data: "#{@id}_#{button_id}")
        button_id += 1
        b
      end
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end
end
