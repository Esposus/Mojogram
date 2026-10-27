from .client import Bot


def start_polling(var bot: Bot) raises:
    """Starts the bot by continuously fetching and processing updates."""
    var offset = 0
    while True:
        var updates = bot.get_updates(offset)
        offset = bot.process_updates(updates^, offset)