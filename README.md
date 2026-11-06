# Omarchy desktop

NittyGriddy, the focused-window frame, and the Quake console, on Tokyo Night.

What you get:

- NittyGriddy from [timsonner/nitty-griddy](https://github.com/timsonner/nitty-griddy), pinned at `f5f1375`. Three-finger swipe up opens every window. Three-finger swipe down dismisses that grid and does not open the menu. A click on a card reaches the card.
- Tokyo Night.
- A 6px border on the focused window, in the theme's bright magenta. Other windows have no border.
- Clicking a window gives it focus, including one that sits in front of a stack. A floating window you focus comes forward.
- The Quake console from [timsonner/quake-console](https://github.com/timsonner/quake-console), pinned at `b13fbaa`. Super+` opens it.
- Files keeps solid text and icons. Its background is 48% opaque, so the desktop shows through. Reopen Files after installing.

Left and right three-finger swipes still change workspace. Super+` opens the console. Super+Space opens the menu.

## Install

On an Omarchy machine, from this directory:

```bash
./install
```

The script is safe to run again. It copies files into `~/.config` and does not remove them.
