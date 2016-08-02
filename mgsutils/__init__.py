try:
    from pathlib import Path
    Path().expanduser()
except (AttributeError,ImportError):
    from pathlib2 import Path
