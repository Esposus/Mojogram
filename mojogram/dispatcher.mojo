"""Dispatcher is responsible for routing incoming updates to the appropriate command handlers.
It maintains a list of routers and invokes them in order until a match is found.
"""

from .client import Bot
from .router import Router
from .types import Update


struct Dispatcher:
    var routers: List[Router]

    def __init__(out self):
        self.routers = List[Router]()

    def include_router(mut self, var router: Router):
        self.routers.append(router^)
    
    def dispatch(self, mut bot: Bot, imm update: Update) raises -> Bool:
        for router in self.routers:
            if router.dispatch(bot, update):
                return True
        
        return False