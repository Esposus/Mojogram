from std.os import getenv
from std.time import time

from bot import Bot, Update


def main() raises:
    print("Mojo bot startis 🔥")
    var bot = Bot(getenv("TOKEN"))
    var offset = 0
    while True:
        var updates = bot.get_updates(offset)
        offset = process_updates(bot, updates^, offset)


def process_updates(mut bot: Bot, var updates: List[Update], offset: Int) raises -> Int:
    var offset_inner = offset
    for update in updates:
        try:
            offset_inner = handle_update(bot, update)
        except e:
            print("Failed to process a message:", e)
    return offset_inner


def handle_update(mut bot: Bot, update: Update) raises -> Int:
    if update.message:
        var message = update.message.value().copy()
        if message.`from` and message.`from`.value().id == 33767888:
            _ = bot.copy_message(message.chat.id, message.chat.id, message.message_id)
        else:
            _ = bot.forward_message(message.chat.id, message.chat.id, message.message_id)
    return update.update_id + 1