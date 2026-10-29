from .client import Bot
from .types import Update


comptime Handler = def(mut Bot, Update) raises thin -> None


struct CommandRoute(Copyable):
    """Represents a command and its associated handler."""

    var command: String
    var handler: Handler

    def __init__(out self, var command: String, handler: Handler):
        self.command = command^
        self.handler = handler


struct MessageRoute(Copyable):
    """Represents a message and its associated handler."""

    var handler: Handler

    def __init__(out self, handler: Handler):
        self.handler = handler


struct Router(Copyable, Movable):
    """Routes incoming updates to the appropriate command handlers."""

    var commands: List[CommandRoute]
    var messages: List[MessageRoute]

    def __init__(out self):
        """Initializes the router with an empty list of command routes."""
        self.commands = List[CommandRoute]()
        self.messages = List[MessageRoute]()

    def on_command(mut self, var command: String, handler: Handler):
        """Registers a command handler for the specified command."""
        self.commands.append(CommandRoute(command^, handler))
    
    def on_message(mut self, handler: Handler):
        """Registers a message handler."""
        self.messages.append(MessageRoute(handler))
    
    def dispatch(self, mut bot: Bot, update: Update) raises -> Bool:
        """Dispatches the update to the appropriate command handler if a matching command is found.

            Returns: True if a command was handled, otherwise False.
        """

        if not update.message:
            return False
        
        var message = update.message.value().copy()

        if not message.text:
            return False
        
        var text = message.text.value().copy()

        for route in self.commands:
            if text.startswith("/" + route.command):
                route.handler(bot, update)
                return True

        for route in self.messages:
            route.handler(bot, update)
            return True

        return False
