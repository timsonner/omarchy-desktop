# Omarchy desktop

The window overview, the trackpad swipes that open and close it, and the focused-window frame, on Tokyo Night.

What you get:

- Exposé from [kristofferR/omarchy-expose](https://github.com/kristofferR/omarchy-expose), pinned at `f283002`. The hot corner is off, so the swipe is what opens it.
- Three-finger swipe up shows the open windows. Three-finger swipe down closes that overview and does not open the menu.
- Tokyo Night.
- A 6px border on the focused window, in the theme's bright magenta. Other windows have no border.
- The Quake console from [timsonner/quake-console](https://github.com/timsonner/quake-console), pinned at `b13fbaa`. Super+` opens it.
- Files keeps solid text and icons. Its background is 48% opaque, so the desktop shows through. Reopen Files after installing.

Left and right three-finger swipes still change workspace. Super+Space still opens the menu.

## Install

On an Omarchy machine, from this directory:

```bash
./install
```

The script is safe to run again. It copies files into `~/.config` and does not remove them.
