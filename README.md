# Omarchy desktop

NittyGriddy, the focused-window frame, and the Quake console, on Tokyo Night.

What you get:

- NittyGriddy from [timsonner/nitty-griddy](https://github.com/timsonner/nitty-griddy), pinned at `fc0ad3a`. Three-finger swipe up opens the grid on All. Three-finger swipe down dismisses it and does not open the menu. While the grid is open, swipe right pages through workspace 1, 2, 3, and so on, and swipe left pages back toward All. The desktop workspace stays put. While the grid is closed, swipe left and right move to the previous and next workspace. A click on a card reaches the card. Keyboard shortcuts are in that plugin’s README. This installer does not change keybindings.
- Tokyo Night.
- A 6px border on the focused window, in the theme's bright magenta. Other windows have no border.
- Clicking a window gives it focus, including one that sits in front of a stack. A floating window you focus comes forward.
- The Quake console from [timsonner/quake-console](https://github.com/timsonner/quake-console), pinned at `b13fbaa`. Super+` opens it.
- Files keeps solid text and icons. Its background is 48% opaque, so the desktop shows through. Reopen Files after installing.

Super+` opens the console. Super+Space opens the menu. Super+W and Super+Q still close the focused window. They are not rebound here.

## Install

On an Omarchy machine, from this directory:

```bash
./install
```

The script is safe to run again. It copies files into `~/.config` and does not remove them.
