Build Signal Desktop for Fedora 35
==================================

This builds a Signal Desktop AppImage file for Fedora within a Podman container.

Why does it exist?

The official [Signal Desktop releases](https://signal.org/download/) are only available for Windows, Mac and Debian-based Linux distributions. 

On Fedora Linux, one simple option to run Signal would be the [Signal Desktop Snap](https://snapcraft.io/signal-desktop). It is created by third parties and packages the Debian-build of Signal Desktop into a Snap. I had several issues with this: 

- I do not want to use Snaps as of yet
- I do have trust issues, even when I can read the [source code of the Snap](https://github.com/snapcrafters/signal-desktop)

So I took it upon me to compile Signal to AppImage inside a Podman container.

Prerequisities
--------------

This project was tested on Fedora 35 (Gnome) with Podman.

For convenience, create a desktop entry for Signal on your host system:

```bash
nano ~/.local/share/applications
```

Add desktop entry, replace the path to `Signal.AppImage` with your system's values:

```ini
[Desktop Entry]
Encoding=UTF-8
Name=Signal Desktop
Comment=Private messaging from your desktop.
Exec=/home/gk/Tools/Signal.AppImage --use-tray-icon --no-sandbox
Icon=signal-desktop
StartupWMClass=Signal
Type=Application
Categories=Office;
```

Attention: Only add `--use-tray-icon` in the desktop entry when you have a Gnome extension to display tray icons (such as [Tray Icons: Reloaded](https://github.com/MartinPL/Tray-Icons-Reloaded)) enabled. Otherwise remove the flag.

How It Works
------------

`main.sh` executes `build.sh`, `run.sh` and `cleanup.sh`:

- `build.sh` - Builds a Podman container that compiles the latest stable Signal Desktop version to an AppImage. It replaces the default build target "deb" (for Debian-based distros) with the "AppImage" build target. The result is a Signal.AppImage file, which is Linux platform independent.
- `run.sh` - Runs the container "build-signal-desktop": A Python3 HTTP server is started that serves the `release/` directory on port 8080 as directory listing. Then, the script downloads the Signal.AppImage file into `~/Tools/Signal.AppImage` and stops and removes the Podman container.
- `cleanup.sh` - Removes txt files and json files.

Usage
-----

Run `main.sh` and grab a coffee, it will take a while. When the script is done, there should be `~/Tools/Signal.AppImage`.

When everything is done and you created the desktop entry as described above, you should now be able to look for Signal after pressing the Super key.