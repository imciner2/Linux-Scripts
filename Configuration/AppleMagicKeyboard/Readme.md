# Using the Apple Magic Keyboard on Linux

The following describes how to use the UK-variant of the Apple Magic Keyboard on Linux using X11 as the backend.

## Enabling function keys by default

To enable the function keys to default to their `Fn`... behavior with no modifiers instead of their alternate behavior, place the `hid_apple.conf` file into `/etc/modprobe.d/`.
This will is the startup-equivalent of putting `2` inside `/sys/module/hid_apple/parameters/fnmode`.

The settings for the function keys are:
* `0` - disabled : Disable the 'fn' key. Pressing 'fn'+'F8' will behave like you only press 'F8'
* `1` - fkeyslast : Function keys are used as last key. Pressing 'F8' key will act as a special key. Pressing 'fn'+'F8' will behave like a F8.
* `2` - fkeysfirst : Function keys are used as first key. Pressing 'F8' key will behave like a F8. Pressing 'fn'+'F8' will act as special key (play/pause).


## Key mapping

Unfortuently, choosing the UK Macintosh layout (which has the pound sign in the correct place), ends up switching the numpad enter key to be a level 3 shift key.
To fix this in a way that will automatically fix it when the keyboard is added over Bluetooth or USB, a user systemd service can be used.

First, create the following directory structure in $HOME (note, the files can be symlinks to the ones in the repo if desired):
```
$HOME/
⮡local/
  ⮡bin/
    ⮡fixKeyboard.py
  ⮡share/
    ⮡xkbd/
      ⮡keymaps/
        ⮡magic_keymap
      ⮡symbols/
        ⮡magickbd
```

Next, install the systemd service (this can also be a symlink):
```
mkdir -p $HOME/.config/systemd/user/
cp magic-keyboard-fixer.service $HOME/.config/systemd/user/
```

Once those are installed, simply enable and start the service:
```
systemctl --user daemon-reload
systemctl --user enable magic-keyboard-fixer.service
systemctl --user start magic-keyboard-fixer.service
```
