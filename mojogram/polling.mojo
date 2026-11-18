from .client import Bot
from .dispatcher import Dispatcher


struct Polling:
    """Owns the bot and dispatcher for sequential long polling."""

    var bot: Bot
    var dispatcher: Dispatcher

    def __init__(out self, var bot: Bot, var dispatcher: Dispatcher):
        self.bot = bot^
        self.dispatcher = dispatcher^

    def start(mut self, skip_updates: Bool = False) raises:
        """Starts receiving updates and dispatching them in order.

        Handler and request errors propagate to the caller. With
        `skip_updates=True`, polling starts at the last pending update;
        the last update is still processed, not discarded.
        """
        var offset = -1 if skip_updates else 0

        while True:
            var updates = self.bot.get_updates(offset)
            for update in updates:
                _ = self.dispatcher.dispatch(self.bot, update)
                offset = update.update_id + 1
