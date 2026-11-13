# Omarchy desktop

Installer for one Omarchy desktop: NittyGriddy on three-finger swipes, a 6px frame on the focused window, click-to-focus, the Tokyo Night theme, the Quake console, and a translucent Files window.

`./install` copies the Lua and CSS from this repository into `~/.config`, checks out two pinned projects, and sets the theme. The script is safe to run again. It copies files into place and leaves those copies on disk.

## Prerequisites

Run this on an Omarchy machine. The installer expects:

- `omarchy` on `PATH`
- `bash`, `python3`, `git`, and `install` (coreutils)
- `fc-cache`, which the pinned Quake console installer runs
- `HOME` set
- These files already present:
  - `~/.config/hypr/hyprland.lua`
  - `~/.config/hypr/input.lua`
  - `~/.config/hypr/looknfeel.lua`
- Network access to GitHub, so it can fetch the pinned commits

`hyprctl` is optional. When it is on `PATH` and `HYPRLAND_INSTANCE_SIGNATURE` is set, the installer reloads Hyprland after the other steps.

Check the required commands:

```bash
command -v bash python3 git install omarchy fc-cache
```

## Install

From this directory:

```bash
./install
```

This repository has no build step and no test suite. `./install` is the only project command. Check that the script parses with:

```bash
bash -n ./install
```

If `~/.config/hypr/input.lua` or `~/.config/hypr/looknfeel.lua` is missing, the installer prints `missing` and that path, then exits 1. `~/.config/hypr/hyprland.lua` has to exist as well.

What `./install` changes:

1. Copies `hypr/gestures.lua`, `hypr/frame.lua`, and `hypr/focus.lua` to `~/.config/hypr/` (mode `644`).
2. Writes `gtk/nautilus.css` into `~/.config/gtk-4.0/gtk.css` between the markers `/* omarchy-desktop: nautilus */` and `/* omarchy-desktop: nautilus end */`. On a later run the block between those markers is replaced.
3. In `~/.config/hypr/input.lua`, deletes from the line `-- Three-finger swipe up shows the open windows (Exposé).` through the end of the file. Text before that line stays.
4. In `~/.config/hypr/looknfeel.lua`, deletes from the line `-- 6px frame on the focused window only` through the end of the file. Text before that line stays.
5. Appends these lines to `~/.config/hypr/hyprland.lua` when neither require is already there:

   ```lua
   require("hypr.gestures")
   require("hypr.frame")
   ```

   If only one of those requires is present, the installer prints `hyprland.lua requires only one of gestures.lua and frame.lua` and exits 1.
6. Appends `require("hypr.focus")` when that line is absent.
7. If `~/.config/omarchy/plugins/timsonner.nitty-griddy` does not exist, runs:

   ```bash
   omarchy plugin add https://github.com/timsonner/nitty-griddy.git --enable --yes
   ```

8. If that directory is a git checkout and `HEAD` is not `fc0ad3aa90be736a440d1c17a48ac1d3e97939b3`, fetches and checks out that commit. A dirty worktree stops the run. The installer prints `plugin timsonner.nitty-griddy has local changes; left it at <commit>` and exits 1.
9. Ensures `~/.config/omarchy/shell.json` lists `{ "id": "timsonner.nitty-griddy" }`. A missing file is created as `{ "version": 1, "plugins": [ { "id": "timsonner.nitty-griddy" } ] }`.
10. Fetches `https://github.com/timsonner/quake-console.git` at `b13fbaa1032346c52975872cc01ed4e723c13d35` and runs that tree's `./install`.
11. Reads the theme name from `theme` (`Tokyo Night`). When `omarchy theme current` is different, runs:

    ```bash
    omarchy theme set "Tokyo Night"
    ```

12. Runs `hyprctl reload` when `hyprctl` is on `PATH` and `HYPRLAND_INSTANCE_SIGNATURE` is set.

Pins live in `plugin/timsonner.nitty-griddy` and `quake-console`:

| File | Fields |
| --- | --- |
| `plugin/timsonner.nitty-griddy` | `id=timsonner.nitty-griddy`, `url=https://github.com/timsonner/nitty-griddy.git`, `commit=fc0ad3aa90be736a440d1c17a48ac1d3e97939b3` |
| `quake-console` | `url=https://github.com/timsonner/quake-console.git`, `commit=b13fbaa1032346c52975872cc01ed4e723c13d35` |
| `theme` | `Tokyo Night` |

## Usage

Three-finger swipes come from `hypr/gestures.lua`:

- Up dispatches `timsonner.nitty-griddy:open`.
- Down dispatches `timsonner.nitty-griddy:close`. When the overview is already closed, that event does nothing. It does not open the Quake console or the Omarchy menu.
- While a layer in the namespace `timsonner-nitty-griddy` is mapped, left dispatches `timsonner.nitty-griddy:workspace-prev` and right dispatches `timsonner.nitty-griddy:workspace-next`. The gesture file describes those pages as All, then workspace 1, 2, 3, and so on. Right moves forward. Left moves back toward All. The desktop workspace stays put.
- While that layer is absent, left focuses workspace `r-1` and right focuses workspace `r+1`.

`hypr/focus.lua` binds mouse button 272 (left click). The click focuses the window under the pointer, and a floating window that is focused is raised. When the pointer is on the NittyGriddy layer, the bind leaves the click for the card.

`hypr/frame.lua` sets a 6px border on the focused window. The color is `bright_magenta` from `$XDG_STATE_HOME/omarchy/current/theme/colors.toml`, or from `~/.local/state/omarchy/current/theme/colors.toml` when `XDG_STATE_HOME` is unset. The fallback color is `#bb9af7`. Unfocused windows use border size 0 and a transparent inactive border.

`gtk/nautilus.css` sets Files (Nautilus) window, view, header bar, and sidebar backgrounds to 48% opacity. The CSS does not change text or icon colors. Reopen Files after installing so it picks up the background.

When the installer finishes, it prints that Super+` opens the Quake console.

If a swipe does nothing after `omarchy restart shell`, the comment in `hypr/gestures.lua` says the shell is not seeing socket2 custom events. Replace the open and close `hl.dispatch` calls in that file with:

```lua
hl.dispatch(hl.dsp.exec_cmd("omarchy-shell shell summon timsonner.nitty-griddy '{}'"))
hl.dispatch(hl.dsp.exec_cmd("omarchy-shell shell hide timsonner.nitty-griddy"))
```

## Layout

```
install                         bash installer
theme                           one line: Tokyo Night
quake-console                   Quake console URL and commit
plugin/timsonner.nitty-griddy  plugin id, URL, and commit
hypr/gestures.lua               three-finger swipes
hypr/frame.lua                  focused-window border
hypr/focus.lua                  click to focus and raise
gtk/nautilus.css                Files background opacity
```

## License

This repository has no license file.
