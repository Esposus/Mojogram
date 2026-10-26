from bot import Bot, Update
from std.time import time
from std.os import getenv


def main() raises:
    print("Mojo bot startis 🔥")
    var bot = Bot(getenv("TOKEN"))
    var offset = 0
    while True:
        var updates = bot.get_updates(offset)
        for update in updates:
            if update.message:
                var message = update.message.value().copy()
                if message.`from` and message.`from`.value().id == 33767888:
                    try:
                        _ = bot.copy_message(message.chat.id, message.chat.id, message.message_id)
                    except e:
                        print("Failed to copy message:", e)
                else:
                    try:
                        _ = bot.forward_message(message.chat.id, message.chat.id, message.message_id)
                    except e:
                        print("Failed to forward message:", e)
            offset = update.update_id + 1
