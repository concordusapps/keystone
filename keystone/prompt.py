import sys
from .terminal import colored, cursor, screen, getch, Key


configuration = {}


def prompt(name, message=None, default=None, values=None):
    """Prompt the user for some input.
    """

    if message is None:
        # No message was provided; use the name as the message.
        message = name

    if name in configuration:
        # Configuration value already present.
        return configuration[name]

    # Display prompt message.
    sys.stdout.write(colored('[', 'white', attrs=['dark']))
    sys.stdout.write(colored('?', 'green'))
    sys.stdout.write(colored(']', 'white', attrs=['dark']))
    sys.stdout.write(' ')
    sys.stdout.write(message)
    sys.stdout.write(': ')

    if values is None:
        # Display default value.
        default_text = '(%s) ' % default
        sys.stdout.write(default_text)
        sys.stdout.flush()

        # Prompt for the input.
        value = input()

        # Store in the configuration hash.
        configuration[name] = value or default

    else:
        # Write out help text.
        sys.stdout.write(colored(
            '(use arrow keys to make selection)', 'white', attrs=['dark']))

        # Write out choices for the user.
        sys.stdout.write('\n')
        sys.stdout.write(colored('   \u2192 %s' % values[0], 'cyan'))
        for value in values[1:]:
            sys.stdout.write('\n     %s' % value)

        # Prepare menu.
        total = len(values)
        index = 0

        # Make a few helper functions.
        def select(item):
            nonlocal index

            # Unselect current.
            screen.clear_line()
            sys.stdout.write('     %s' % values[index])
            sys.stdout.write('\r')

            # Select new.
            cursor.move(rows=(item - index))
            index = item
            screen.clear_line()
            sys.stdout.write(colored('   \u2192 %s' % values[index], 'cyan'))
            sys.stdout.write('\r')
            sys.stdout.flush()

        # Hide cursor.
        cursor.hide()

        # Move "cursor" back to the first entry.
        cursor.move(rows=-(len(values) - 1))
        sys.stdout.write('\r')

        # Wait for keypress and faciliate menu.
        while True:
            key = getch(all=True)
            if key == Key.DOWN and index < (total - 1):
                # Move cursor down one.
                select(index + 1)

            elif key == Key.UP and index > 0:
                # Move cursor down one.
                select(index - 1)

            elif key == Key.ENTER:
                # Mark this value as selected.
                configuration[name] = value = values[index]
                break

        # Clear menu.
        cursor.move(rows=total - 1 - index)
        index = total - 1
        while index > 0:
            screen.clear_line()
            cursor.move(rows=-1)
            index -= 1

        sys.stdout.flush()

        # Show cursor.
        cursor.show()

    # Restore the cursor position and write out the selected value.
    cursor.move(rows=-1, columns=len(message) + 6)
    value_text = configuration[name] or 'none'
    sys.stdout.write(colored(value_text, 'cyan'))
    screen.clear_line(part='after')
    sys.stdout.write('\n')
    sys.stdout.flush()

    # Return for convenience
    return value
