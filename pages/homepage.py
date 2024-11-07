# string_utils.py

from robot.api.deco import keyword

@keyword
def trim_whitespace(text):
    # Remove leading/trailing whitespace and normalize line breaks
    return text.strip().replace("\n", "").replace("\r", "")
