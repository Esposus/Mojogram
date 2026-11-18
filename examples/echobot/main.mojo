from std.logger import Logger, Level
from std.os import getenv

from mojogram import Bot, Dispatcher, Polling, Router
from mojogram.types import Update

comptime logger = Logger[Level.INFO](prefix="[mojogram.echobot.main] ")


def start(mut bot: Bot, update: Update) raises:
    ref message = update.message.value()
    bot.send_message(
        message.chat.id,
        "Привет! Отправь текст, и я повторю его. /help — справка.",
    )


def help_command(mut bot: Bot, update: Update) raises:
    ref message = update.message.value()
    bot.send_message(
        message.chat.id,
        "/start — приветствие\n/help — справка\nОстальной текст я повторяю.",
    )


def echo(mut bot: Bot, update: Update) raises:
    ref message = update.message.value()
    bot.send_message(message.chat.id, message.text.value())


def main() raises:
    var token = getenv("TOKEN")
    if token == "":
        raise Error("Set the TOKEN environment variable before starting echobot")

    var bot = Bot(token^)

    var router = Router()
    router.on_command("/start", start)
    router.on_command("/help", help_command)
    router.on_message(echo)

    var dispatcher = Dispatcher()
    dispatcher.include_router(router^)

    var polling = Polling(bot^, dispatcher^)
    logger.info("Echobot started")
    polling.start()
