import curses

# Tried to conform to PEP8, i don't think its going to happen here.


class Disclaimer:

    def initwin(self):
        window = curses.initscr()
        window.clear()
        window.border(0)
        window.addstr(10, 10, "Disclaimer:")
        window.addstr(
            14, 10, "Keystone, while awesome, is definitely in an alpha stage and is largely untested in the wild.")
        window.addstr(
            15, 10, "Just because the authors have stated that this works in their various environments does not ")
        window.addstr(
            16, 10, "mean it will work in yours. The authors are not responsible if your computer turns into a ")
        window.addstr(
            17, 10, "toaster, fights back, explodes,  installs arch linux, achieves sentience, or any variation of")
        window.addstr(18, 10, "not working not described thus far.")
        window.addstr(
            21, 10, "If you are content with the disclaimer above, press any key to continue.")
        window.refresh()
        window.getch()
        curses.endwin()
