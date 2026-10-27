from .client import Bot
from .types import Update


comptime Handler = def(mut Bot, Update) raises thin -> None


struct CommandRoute(Copyable):
    pass


struct Router(Movable):
    pass
