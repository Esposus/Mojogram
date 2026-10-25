from std.os import getenv
from std.time import time

from emberjson import from_json
from floki.response import Response
from floki.session import Session
from floki.timeout import Timeout


struct Bot:
    """Mojogram"""
    var client: Session
    var token: String

    def __init__(out self) raises:
        self.client = Session(timeout=Timeout(connect=5.0, total=40.0))
        self.token = getenv("TOKEN")

    def get_updates(mut self, offset: Int = 0, timeout: Int = 30) raises -> List[Update]:
        var url = String(t"https://api.telegram.org/bot{self.token}/getUpdates?offset={offset}&timeout={timeout}")
        var response: Response = self.client.get(url)
        response.raise_for_status()

        var data = response.as[UpdateResponse]()

        if not data.ok:
            raise Error("Telegram API returned ok=false")

        var updates = List[Update]()
        swap(updates, data.result)
        return updates^

    def send_message(mut self, chat_id: Int, text: String) raises:
        var url = String(t"https://api.telegram.org/bot{self.token}/sendMessage")
        var response = self.client.post(
            url,
            data={
                "chat_id": chat_id,
                "text": text,
            },
        )
        response.raise_for_status()

    def copy_message(
        mut self,
        chat_id: Int,
        from_chat_id: Int,
        message_id: Int,
    ) raises -> Int:
        var url = String(t"https://api.telegram.org/bot{self.token}/copyMessage")

        for attempt in range(3):
            var response = self.client.post(
                url,
                data={
                    "chat_id": chat_id,
                    "from_chat_id": from_chat_id,
                    "message_id": message_id,
                },
            )
            var data = response.as[CopyMessageResponse]()

            if data.error_code and data.error_code.value() == 429 and data.parameters:
                var seconds = data.parameters.value().retry_after

                if seconds > 0 and attempt < 2:
                    print("Лимит Telegram. Ожидание:", seconds)
                    time.sleep(Float64(seconds) + 1.0)
                    continue

            response.raise_for_status()

            if not data.ok:
                raise Error("Telegram copyMessage returned ok=false")

            if not data.result:
                raise Error("Telegram copyMessage response missing result")

            return data.result.value().message_id

        raise Error("Retry limit exceeded")

    def forward_message(
        mut self,
        chat_id: Int,
        from_chat_id: Int,
        message_id: Int,
    ) raises -> Message:
        var url = String(t"https://api.telegram.org/bot{self.token}/forwardMessage")

        for attempt in range(3):
            var response = self.client.post(
                url,
                data={
                    "chat_id": chat_id,
                    "from_chat_id": from_chat_id,
                    "message_id": message_id,
                },
            )
            var data = response.as[ForwardMessageResponse]()

            if data.error_code and data.error_code.value() == 429 and data.parameters:
                var seconds = data.parameters.value().retry_after

                if seconds > 0 and attempt < 2:
                    print("Лимит Telegram. Ожидание:", seconds)
                    time.sleep(Float64(seconds) + 1.0)
                    continue

            response.raise_for_status()

            if not data.ok:
                raise Error("Telegram forwardMessage returned ok=false")

            if not data.result:
                raise Error("Telegram forwardMessage response missing result")

            return data.result.value().copy()

        raise Error("Retry limit exceeded")


struct UpdateResponse(Defaultable, Movable):
    var ok: Bool
    var result: List[Update]

    def __init__(out self):
        self.ok = False
        self.result = List[Update]()


struct Update(Copyable, Defaultable):
    var update_id: Int
    var message: Optional[Message]

    def __init__(out self):
        self.update_id = 0
        self.message = Optional[Message]()


struct Message(Defaultable, Copyable, Writable):
    var message_id: Int
    var chat: Chat
    var `from`: Optional[From]
    var text: Optional[String]

    def __init__(out self):
        self.message_id = 0
        self.chat = Chat()
        self.`from` = Optional[From]()
        self.text = Optional[String]()

    def write_to(self, mut writer: Some[Writer]):
        writer.write(t"Message(id={self.message_id}, chat_id={self.chat.id}, text={self.text})")


@fieldwise_init
struct From(Copyable):
    var id: Int


struct Chat(Copyable):
    var id: Int

    def __init__(out self):
        self.id = 0


struct MessageId(Movable):
    var message_id: Int

    def __init__(out self):
        self.message_id = 0


struct ResponseParameters(Movable):
    var retry_after: Int

    def __init__(out self):
        self.retry_after = 0


struct CopyMessageResponse(Defaultable, Movable):
    var ok: Bool
    var result: Optional[MessageId]
    var error_code: Optional[Int]
    var parameters: Optional[ResponseParameters]

    def __init__(out self):
        self.ok = False
        self.result = Optional[MessageId]()
        self.error_code = Optional[Int]()
        self.parameters = Optional[ResponseParameters]()


struct ForwardMessageResponse(Defaultable, Movable):
    var ok: Bool
    var result: Optional[Message]
    var error_code: Optional[Int]
    var parameters: Optional[ResponseParameters]

    def __init__(out self):
        self.ok = False
        self.result = Optional[Message]()
        self.error_code = Optional[Int]()
        self.parameters = Optional[ResponseParameters]()
