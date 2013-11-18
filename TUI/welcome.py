import curses


class Welcome:

    def initwin(self):
        window = curses.initscr()
        window.clear()

        window.border(0)
        window.addstr(2, 5, "Welcome!")
        window.addstr(
            5, 10, "Welcome to keystone, the automated Arch Linux installer!")
        window.addstr(
            6, 10, "Please note, this installer automatically assumes you")
        window.addstr(
            7, 10, "have mounted your partition at /mnt, and that you are")
        window.addstr(
            8, 10, "connected to the internet. If you are unsure about how")
        window.addstr(
            9, 10, "to do any of these things, please consult the Arch Wiki")
        window.addstr(10, 10, "for instructions.")
        window.getch()
        curses.endwin()
