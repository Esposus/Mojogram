# Mojogram

```bash
Mojogram/
├── mojogram/
│   ├── client.mojo          # Bot: методы Telegram API
│   ├── types.mojo           # Update, Message, Chat...
│   ├── polling.mojo         # получение обновлений и offset
│   └── errors.mojo          # ошибки библиотеки
├── examples/
│   └── echo_bot/
│       └── main.mojo        # запуск и обработчики конкретного бота
├── tests/
├── pixi.toml
└── README.md
```

## TODO:

- `Bot` Выполнить запрос к Telegram.
- `Polling` Получить обновления и подтвердить обработанные.
- `Dispatcher` Передать обновление подходящим обработчикам.
- `Router` Объединить обработчики и их фильтры: команды, сообщения, кнопки.
