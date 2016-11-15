require_relative '../../game/collection'
require_relative '../../game/exception'

class Telegram::Bot::GameClient < Telegram::Bot::Client
  attr_accessor :bot, :games

  def handle_callback(message)
    game = @games.find_by_callback(message.from.id, message.data)
    if game.victory?
      # already won
      @bot.api.answer_callback_query(callback_query_id: message.id, text: 'You have already won!')
    else
      if game.move_by_callback(message.data)
        @bot.api.answer_callback_query(callback_query_id: message.id, text: 'Good move')
        @bot.api.edit_message_text(
          chat_id: game.chat_id,
          message_id: game.msg_id,
          text: 'Your next move',
          reply_markup: game.markup
        )
        if game.victory?
          # just won
          @bot.api.send_message(chat_id: game.chat_id, text: 'Congrats! Try on a higher difficulty')
        end
      else
        @bot.api.answer_callback_query(callback_query_id: message.id, text: "Can't move")
      end
    end
  rescue GameException => e
    @bot.api.answer_callback_query(callback_query_id: message.id, text: "Game error: #{e}")
    @bot.logger.error(e)
  rescue RuntimeError => e
    @bot.logger.error(e)
  end

  def handle_message(message)
    command = message.text.match(%r{^/(\w+)(?:\s+(\d+))?})
    if command.nil?
      @bot.api.send_message(chat_id: message.chat.id, text: 'Say again')
    elsif command[1] == 'start'
      g = games.start(message.from.id, command[2].to_i)
      msg = @bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Make your move',
        reply_markup: g.markup
      )
      g.attach(msg)
    elsif command[1] == 'stop'
      games.stop(message.from.id)
      markup = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
      @bot.api.send_message(chat_id: message.chat.id, text: 'Farewell', reply_markup: markup)
    else
      @bot.api.send_message(chat_id: message.chat.id, text: 'Unknown command')
    end
  rescue GameException => e
    @bot.api.send_message(chat_id: message.chat.id, text: "Game error: #{e}")
  rescue RuntimeError => e
    @bot.api.send_message(chat_id: message.chat.id, text: 'Internal error. Please contact the admin')
    @bot.logger.error(e)
  end

  def run
    super do |bot|
      @bot = bot
      @games = GameCollection.new

      @bot.listen do |message|
        case message
        when Telegram::Bot::Types::CallbackQuery
          handle_callback(message)
        when Telegram::Bot::Types::Message
          handle_message(message)
        end
      end
    end
  end
end
