import logging
import sys
from logging.handlers import TimedRotatingFileHandler

LOG_FILE = "backend_python/logs/forex_companion.log"

def setup_logging(log_level=logging.INFO):
    """Set up the logging configuration."""
    logger = logging.getLogger()
    logger.setLevel(log_level)

    # Create handlers
    console_handler = logging.StreamHandler(sys.stdout)
    file_handler = TimedRotatingFileHandler(LOG_FILE, when="midnight", interval=1, backupCount=5)

    # Create formatters and add it to handlers
    log_format = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    console_handler.setFormatter(log_format)
    file_handler.setFormatter(log_format)

    # Add handlers to the logger
    # Avoid adding handlers if they already exist
    if not logger.handlers:
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)

    return logger
