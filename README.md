# Mojogram

## Запуск echobot

Основной интерфейс получения обновлений — `Polling`: он владеет `Bot`
и `Dispatcher`, а `start()` запускает последовательную обработку.
Пример находится в `examples/echobot/main.mojo`: `/start` показывает
приветствие, `/help` — справку, остальные текстовые сообщения повторяются.

Из корня репозитория:

```bash
pixi run mojo build -I . examples/echobot/main.mojo -o examples/echobot/main
read -rs -p 'Telegram bot token: ' TOKEN
export TOKEN
pixi run ./examples/echobot/main
```

`TOKEN` читается при запуске; без него пример завершится до создания
HTTP-клиента. Не добавляйте токен в исходники и команды, сохраняемые в истории.

Сборка приложения выполняется в таком порядке:

```mojo
var dispatcher = Dispatcher()
dispatcher.include_router(router^)
var polling = Polling(bot^, dispatcher^)
polling.start()
```

Здесь `bot` и настроенный `router` созданы заранее. После передачи через `^`
приложение больше не обращается к исходным переменным.

Функция `start_polling` удалена. Для миграции замените импорт на
`from mojogram import Polling`, создайте `Polling(bot^, dispatcher^)`
и вызовите `start()` у сохранённого экземпляра, как в примере выше.
Диспетчер теперь передаётся во владение Polling, поэтому после `dispatcher^`
исходная переменная больше не используется.

`start()` блокирует вызывающий поток и передаёт ошибки вызывающему коду.
Остановка и повторы после ошибок пока не реализованы.
`Polling.start(skip_updates=True)` пока обрабатывает последнее ожидающее
обновление, а не удаляет всю очередь; полную очистку очереди предстоит добавить.
Команды в этом примере регистрируются со слешем под текущую реализацию Router;
точный разбор команд и их аргументов — отдельная задача.

## Структура

```bash
Mojogram/
├── mojogram/
│   ├── client.mojo          # Bot: методы Telegram API
│   ├── types.mojo           # Update, Message, Chat...
│   ├── polling.mojo         # получение обновлений и offset
│   └── errors.mojo          # ошибки библиотеки
├── examples/
│   └── echobot/
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
