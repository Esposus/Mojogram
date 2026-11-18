from std.testing import TestSuite, assert_equal, assert_true, assert_false

from emberjson import from_json
from mojogram.types import Update


def test_decodes_text_message() raises:
    var update = from_json[Update]("""
        {
            "update_id": 100, 
                "message": {
                    "message_id": 42,
                    "chat": {
                        "id": 123
                    },
                    "text": "hello"
                }
        }
    """)
    assert_equal(update.update_id, 100)
    assert_true(update.message)

    ref message = update.message.value()
    assert_equal(message.message_id, 42)
    assert_equal(message.chat.id, 123)
    assert_true(message.text)
    assert_equal(message.text.value(), "hello")


def test_decodes_empty_text_message() raises:
    var update = from_json[Update]("""
        {
            "update_id": 100, 
                "message": {
                    "message_id": 42,
                    "chat": {
                        "id": 123
                    }
                }
        }
    """)
    assert_equal(update.update_id, 100)
    assert_true(update.message)

    ref message = update.message.value()
    assert_equal(message.message_id, 42)
    assert_equal(message.chat.id, 123)
    assert_false(message.text)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()