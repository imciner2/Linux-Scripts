# Using the Apple Magic Keyboard on Linux

## Enabling function keys by default

To enable the function keys to default to their `Fn`... behavior with no modifiers instead of their alternate behavior, place the `hid_apple.conf` file into `/etc/modprobe.d/`.
This will is the startup-equivalent of putting `2` inside `/sys/module/hid_apple/parameters/fnmode`.

The settings for the function keys are:
* `0` - disabled : Disable the 'fn' key. Pressing 'fn'+'F8' will behave like you only press 'F8'
* `1` - fkeyslast : Function keys are used as last key. Pressing 'F8' key will act as a special key. Pressing 'fn'+'F8' will behave like a F8.
* `2` - fkeysfirst : Function keys are used as first key. Pressing 'F8' key will behave like a F8. Pressing 'fn'+'F8' will act as special key (play/pause).

## Key mapping

By default, the keymap provided for the keyboard is somewhat awkward.
The mapping inside the .Xmodmap file in thsi folder is nicer since it:
* Allows the number pad enter key to act as an enter key (keycode 104)
* Puts the level-3 shift key (for getting the # sign) onto the right option key (keycode 108).
* Makes the left option key act as Alt (keycode 64).
