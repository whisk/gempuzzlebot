#!/usr/bin/env ruby

require_relative 'lib/telegram/bot/game_client'

token = ARGV[0]
raise 'Please provide bot token' unless token

Telegram::Bot::GameClient.run(token, logger: Logger.new($stdout))
