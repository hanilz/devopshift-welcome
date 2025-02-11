import logging
import os
import json
import sys


class JsonFormatter(logging.Formatter):
    def format(self, record) -> str:
        log_record = {
            "level": record.levelname,
            "timestamp": self.formatTime(record, self.datefmt),
            "message": record.getMessage(),
        }
        return json.dumps(log_record)

class InvalidServerNameError(Exception):
    def __init__(self, *args, **kwargs):
        pass

log_level = os.getenv('LOG_LEVEL', 'DEBUG')
log_format = os.getenv('LOG_FORMAT', 'JSON')

logger = logging.getLogger("myapp")


if log_format == 'JSON':
    formatter = JsonFormatter()
else:
    formatter = logging.Formatter("%(asctime)s | %(levelname)s - %(filename)s:%(lineno)d - %(funcName)s - %(message)s")

logging.basicConfig(
    level=log_level,
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler("mylog.log"),
    ]
)

for handler in logging.getLogger().handlers:
    handler.setFormatter(formatter)


servers = {"srv1": True, "srv2": False}

srv = input("Please enter server name to check: ").strip()

if not srv:
    logger.error("Invalid Input!")
    raise InvalidServerNameError("Invalid Input!")
elif srv in servers:
    if servers[srv]:
        logger.info(f"Server {srv} is running.")
    else:
        logger.warning(f"Server {srv} is not running.")
else:
    logger.warning(f"Server {srv} is not recognized.")
