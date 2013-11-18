import curses


class Configuration:

    def __init__(self):
        self.window = curses.initscr()
        self.hostname = "arch"
        self.shell = "bash"
        self.console_font = "Lat2-Terminus16"
        self.console_font_map = "8859-1_to_uni"
        self.language = "en_US.UTF-8"
        self.timezone = "US/Pacific"
        self.username = "administrator"
        self.aur_helper = "aura"
        self.bootloader = "grub"
        self.window_manager = "none"
        self.desktop_env = "none"
        self.login_manager = "none"
        self.network_manager = "wicd"

    def get_input(self, prompt):
        self.window.clear()
        self.window.border(0)
        self.window.addstr(2, 25, prompt)
        self.window.addstr(3, 25, "Type ' ? ' for help ")
        self.window.refresh()
        input = self.window.getstr(5, 25, 60).decode("utf-8")
        return input

    def verify(self, var_to_set, prompt):
        input = self.get_input(prompt)

        if input != "":
            setattr(self, var_to_set, input)

    def initwin(self):

        self.window.clear()
        self.window.border(0)

        self.verify('hostname',
                    "What would you like your hostname to be? (default arch):")

        self.verify('shell',
                    "What shell would you like? (default bash)")

        self.verify('console_font',
                    "What would you like your console font to be? (default Lat2-Terminus16)")

        self.verify('console_font_map',
                    "What console font mapping would you like? (default 8859-1_to_uni)")

        self.verify('language',
                    "What languae would you like? (default en_US.UTF-8)")

        self.verify('timezone',
                    "What timezone are you in? (default US/Pacific)")

        self.verify('username',
                    "What username would you like? (default administrator)")

        self.verify('aur_helper',
                    "What AUR helper would you like? (default aura)")

        self.verify('bootloader',
                    "What bootloader would you like? (default grub)")

        self.verify('window_manager',
                    "What window manager would you like? (default none)")

        self.verify('desktop_env',
                    "What Desktop Environment would you like? (default none)")

        self.verify('login_manager',
                    "What login manager would you like? (default none)")

        self.verify('network_manager',
                    "What network manager would you like?")

        # an example on how to get input:
        # self.window.clear()
        # self.window.addstr(3, 25, "You entered: " + self.hostname)
        # self.window.getch()
        curses.endwin()
