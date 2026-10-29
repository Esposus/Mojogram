from .client import Bot
from .dispatcher import Dispatcher


def start_polling(var bot: Bot, dispatcher: Dispatcher) raises:
    """Starts the bot by continuously fetching and processing updates."""
    var offset = 0

    while True:
        var updates = bot.get_updates(offset)
        for update in updates:
            _ = dispatcher.dispatch(bot, update)
            offset = update.update_id + 1

# TODO:
# 1) отдельная политика ошибок хэндлеров
# 2) остановка приложения и жидание после сетевых ошибок
