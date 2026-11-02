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


struct Polling:
    var bot: Bot
    var dispatcher: Dispatcher

    def __init__(out self, var bot: Bot, var dispatcher: Dispatcher):
        self.bot = bot^
        self.dispatcher = dispatcher^

    def start(mut self, skip_updates: Bool = False) raises:
        var offset = -1 if skip_updates else 0

        while True:
            var updates = self.bot.get_updates(offset)
            for update in updates:
                _ = self.dispatcher.dispatch(self.bot, update)
                offset = update.update_id + 1
