# xmonad-rice

XMonad configuration targeting a focused, distraction-free coding environment. Dark charcoal palette, dwindle layout, minimal xmobar, fast rofi launcher.


---

## Stack

| Role        | Tool                       |
|-------------|----------------------------|
| WM          | XMonad + xmonad-contrib    |
| Bar         | XMobar                     |
| Launcher    | Rofi                       |
| Compositor  | Picom (glx backend)        |
| Terminal    | Alacritty                  |
| Font        | CaskaydiaCove Nerd Font    |
| Notifs      | Dunst                      |

---

## Layout

Primary layout is Dwindle (R, CW) — a Fibonacci-style tiling that splits each new window into the remaining space. Secondary layout is ResizableTall. Both have 4px inner and outer gaps. Full toggle is bound to `M-f`.

Workspaces are plain strings: `dev web sys doc irc` and four numbered fallbacks.

---

## Bar

XMobar runs full-width at the top. Left side receives the xmonad log hook (workspaces, layout name, focused window title). Right side shows CPU usage, RAM usage, and date in `dd/mm/yy HH:MM` format. Stats refresh every second. Colour thresholds are wired into xmobar's normal/high flags — green for normal, red under load.

No icons in the bar. No nerd font glyphs. Plain text only.

---

## Palette

All components share the same colour set:

```
bg          #1a1a1a   base background
bg-alt      #242424   panel / bar background
bg-hover    #2e2e2e   hover / selection trough
border      #3a3a3a   inactive window border
fg          #c8c8c8   primary text
fg-dim      #606060   inactive / secondary text
accent      #5f87af   steel blue — focused border, current workspace, rofi selection
accent2     #87af5f   muted green — window title in bar, active rofi entries
red         #af5f5f   urgent workspaces, high CPU/RAM
yellow      #af875f   layout name in bar, date
```

---

## Keybindings

`M` is Super (Win key).

```
M-Return        open terminal
M-d             rofi drun
M-S-d           rofi run
M-Tab           rofi window switcher
M-q             close focused
M-S-q           close all on workspace
M-S-r           recompile and restart xmonad
M-f             toggle fullscreen
M-a / M-z       shrink / expand slave height
M-. / M-,       next / previous workspace
M-S-. / M-S-,   move window to next / previous workspace
M-Space         cycle layouts
M-h / M-l       shrink / grow master width
M-j / M-k       focus next / previous window
M-S-j / M-S-k   swap windows
M-Print         screenshot (scrot)
M-S-Print       region screenshot
```

---

## Rofi

Hard 0px border radius — matches the rest of the setup. Fuzzy match with fzf sorting. Vim-style navigation (`C-j` / `C-k`). Positioned slightly above centre. Shows app name only, no description clutter.

---

## Picom

GLX backend with vsync. Dual-kawase blur on transparent surfaces. Terminal opacity is 92% focused, 80% unfocused. 0px corner radius everywhere. xmobar is excluded from shadows and blur.

---

## File Locations

```
~/.config/xmonad/xmonad.hs
~/.config/xmobar/xmobarrc
~/.config/rofi/config.rasi
~/.config/picom/picom.conf
~/.config/alacritty/alacritty.toml
```

---

## Notes

Key repeat is set aggressively via `xset r rate 200 50` in the startup hook — 200ms delay, 50 chars/sec. Adjust or remove if that's too fast.

Firefox and Chromium auto-shift to the `web` workspace. Discord goes to `irc`. Add more rules in `myManageHook`.

After editing `xmonad.hs`, press `M-S-r` to recompile and restart in place. XMonad preserves window positions across restarts.
