import sys
import os
import termios
from subprocess import check_call


class screen:

    @classmethod
    def clear_line(cls, part='all'):
        parts = {'all': 2, 'before': 1, 'after': 0}
        sys.stdout.write('\033[%dK' % parts[part])
        sys.stdout.flush()


class cursor:

    @classmethod
    def hide(cls):
        check_call(['setterm', '-cursor', 'off'])

    @classmethod
    def show(cls):
        check_call(['setterm', '-cursor', 'on'])

    @classmethod
    def move(cls, columns=0, rows=0):
        """Move the cursor block the specified number of columns and rows.

        The terminal is arranged such that positive means down or right and
        negative means up or left.
        """

        if columns != 0:
            direction = 'D' if columns < 0 else 'C'
            sys.stdout.write('\033[%d%s' % (abs(columns), direction))

        if rows != 0:
            direction = 'A' if rows < 0 else 'B'
            sys.stdout.write('\033[%d%s' % (abs(rows), direction))

        sys.stdout.flush()


ATTRIBUTES = dict(list(zip([
    'bold',
    'dark',
    '',
    'underline',
    'blink',
    '',
    'reverse',
    'concealed'
], list(range(1, 9)))))
del ATTRIBUTES['']


HIGHLIGHTS = dict(list(zip([
    'on_grey',
    'on_red',
    'on_green',
    'on_yellow',
    'on_blue',
    'on_magenta',
    'on_cyan',
    'on_white'
], list(range(40, 48)))))


COLORS = dict(list(zip([
    'grey',
    'red',
    'green',
    'yellow',
    'blue',
    'magenta',
    'cyan',
    'white',
], list(range(30, 38)))))


RESET = '\033[0m'


def colored(text, color=None, on_color=None, attrs=None):
    """Colorize text.

    Available text colors:
        red, green, yellow, blue, magenta, cyan, white.

    Available text highlights:
        on_red, on_green, on_yellow, on_blue, on_magenta, on_cyan, on_white.

    Available attributes:
        bold, dark, underline, blink, reverse, concealed.

    Example:
        colored('Hello, World!', 'red', 'on_grey', ['blue', 'blink'])
        colored('Hello, World!', 'green')
    """
    if os.getenv('ANSI_COLORS_DISABLED') is None:
        fmt_str = '\033[%dm%s'
        if color is not None:
            text = fmt_str % (COLORS[color], text)

        if on_color is not None:
            text = fmt_str % (HIGHLIGHTS[on_color], text)

        if attrs is not None:
            for attr in attrs:
                text = fmt_str % (ATTRIBUTES[attr], text)

        text += RESET
    return text


def getch(all=False):
    """
    # --- current algorithm ---
    # 1. switch to char-by-char input mode
    # 2. turn off echo
    # 3. wait for at least one char to appear
    # 4. read the rest of the character buffer (_getall=True)
    # 5. return list of characters (_getall on)
    #        or a single char (_getall off)
    """

    fd = sys.stdin.fileno()
    # save old terminal settings
    old_settings = termios.tcgetattr(fd)

    chars = []
    try:
        # change terminal settings - turn off canonical mode and echo.
        # in canonical mode read from stdin returns one line at a time
        # and we need one char at a time (see DESIGN.rst for more info)
        newattr = list(old_settings)
        newattr[3] &= ~termios.ICANON
        newattr[3] &= ~termios.ECHO
        newattr[6][termios.VMIN] = 1   # block until one char received
        newattr[6][termios.VTIME] = 0
        # TCSANOW below means apply settings immediately
        termios.tcsetattr(fd, termios.TCSANOW, newattr)

        # [ ] this fails when stdin is redirected, like
        #       ls -la | pager.py
        #   [ ] also check on Windows
        ch = sys.stdin.read(1)
        chars = [ch]

        if all:
            # move rest of chars (if any) from input buffer
            # change terminal settings - enable non-blocking read
            newattr = termios.tcgetattr(fd)
            newattr[6][termios.VMIN] = 0      # CC structure
            newattr[6][termios.VTIME] = 0
            termios.tcsetattr(fd, termios.TCSANOW, newattr)

            while True:
                ch = sys.stdin.read(1)
                if ch != '':
                    chars.append(ch)
                else:
                    break
    finally:
        # restore terminal settings. Do this when all output is
        # finished - TCSADRAIN flag
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

    if all:
        return chars
    else:
        return chars[0]


class Key:
    LEFT = ['\x1b', '[', 'D']
    UP = ['\x1b', '[', 'A']
    RIGHT = ['\x1b', '[', 'C']
    DOWN = ['\x1b', '[', 'B']
    ENTER = ['\n']
