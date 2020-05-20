
# Configuration files for the System76 Meerkat

These configurations were built for running Fedora 32 on a System76 Meerkat computer (an Intel NUC).

## Sound Configuration

### Front-panel output

In order to use the front-panel headphone/speaker analog port by default, the `.asoundrc` file should be placed in the user's home directory.
This file will tell ALSA to use the frontpanel output as the default.

In addition, pulse audio must be updated to use the front panel by default.

* In a terminal run `pactl list` and fine the entries under `card 0`.
* Inside the `/etc/pulse/defalt.pa` file, add the line (replacing the <card-0-name> with the name of the ALSA card (e.g. `alsa_card.pci-****_**_**.*`)

    ```
    # Make the front panel analog output the default profile
    set-card-profile <card-0-name> output:analog-stereo+input:analog-stereo
    ```

* This can be changed at runtime by running

    ```
    pactl set-card-profile <card-0-name> output:analog-stereo+input:analog-stereo
    ```


### Speaker popping

Approximately 10 seconds after audio stops playing, the speakers make a popping noise.
This is caused by the power management engine shutting off the output device.
To stop this, the `alsa-base.conf` file should be placed inside `/etc/modprobe.d/`.
This file will disable the power management for the sound controller.

This file will ensure the power management is disabled at startup.
To disable it otherwise:

* Change `/sys/module/snd_hda_intel/parameters/power_save` from `1` to `0`
* Change `/sys/module/snd_hda_intel/parameters/power_save_controller` from `Y` to `N`
