import json
from .prompt import prompt, configuration


def configure():
    """Ask for configuration variables for the installation procedure.

    Variables are serialized into a JSON document for the 'install'
    step to consume.
    """

    prompt('hostname', default='keystone')
    prompt('shell', default='bash', values=[
        'bash',
        'zsh'
    ])
    prompt('console font', default='Lat2-Terminus16')
    prompt('console font map', default='8859-1_to_uni')
    prompt('language', default='en_US.UTF-8')
    prompt('timezone', default='US/Pacific')
    prompt('AUR helper', default='aura', values=[
        'aura',
        'yaourt'
    ])
    prompt('bootloader', default='grub', values=[
        'grub'
    ])
    # prompt('boot device')
    # prompt('root password')
    # prompt('re-enter root password')
    prompt('username', default='administrator')
    # prompt('<username> password')
    # prompt('re-enter <username> password')
    prompt('desktop environment', default='none', values=[
        'none',
        'gnome',
        'kde',
        'xfce'
    ])
    prompt('window manager', default='none', values=[
        'none',
        'mutter',
        'awesome',
        'xmonad',
        'openbox'
    ])
    prompt('login manager', default='none', values=[
        'none',
        'gdm',
        'slim'
    ])
    prompt('network manager', default='none', values=[
        'none',
        'wicd',
        'network-manager'
    ])
