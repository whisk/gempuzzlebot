# GemPuzzleBot

GemPuzzleBot for Telegram API

## Usage

1. Prepare and start bot:
```
bundle install --without development test
ruby bot.rb <TOKEN>
```
To exit hit CTRL-C and wait.

2. Add `@GemPuzzleBot` to your Telegram
3. Type `/start` or `/start <difficulty 1..99>` to play, `/stop` to quit
4. You can play on multiple boards at the same time.
5. Enjoy!

## Known issues

* No persistent storage
* Almost no error logging nor error handlind
