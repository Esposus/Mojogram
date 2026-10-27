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


struct From(Copyable):
    var id: Int


struct Chat(Copyable):
    var id: Int

    def __init__(out self):
        self.id = 0


struct MessageId(Defaultable, Movable):
    var message_id: Int

    def __init__(out self):
        self.message_id = 0


struct ResponseParameters(Movable):
    var retry_after: Int

    def __init__(out self):
        self.retry_after = 0


struct TelegramResponse[T: Defaultable & Deinitable & Movable](Defaultable, Movable):
    var ok: Bool
    var result: Optional[Self.T]
    var error_code: Optional[Int]
    var parameters: Optional[ResponseParameters]

    def __init__(out self):
        self.ok = False
        self.result = Optional[Self.T]()
        self.error_code = Optional[Int]()
        self.parameters = Optional[ResponseParameters]()