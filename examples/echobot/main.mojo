from std.logger import Logger, Level
from std.os import getenv

from mojogram.client import Bot
from mojogram.polling import start_polling

comptime logger = Logger[Level.INFO](prefix="[mojogram.echobot.main] ")


def main() raises:
    logger.info("Mojo bot startis 🔥")
    var bot = Bot(getenv("TOKEN"))
    start_polling(bot^)