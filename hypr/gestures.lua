-- Three-finger swipe up shows the open windows (Exposé).
-- This replaces the Quake console on that gesture. Super+` still toggles it.
hl.gesture({ fingers = 3, direction = "up", action = "unset" })
hl.gesture({
  fingers = 3,
  direction = "up",
  action = function()
    hl.dispatch(hl.dsp.event("expose.window-overview:toggle"))
  end,
})

-- Three-finger swipe down closes the overview while it is open.
-- It does not open the Omarchy menu.
hl.gesture({ fingers = 3, direction = "down", action = "unset" })
hl.gesture({
  fingers = 3,
  direction = "down",
  action = function()
    if #hl.get_layers({ namespace = "expose-window-overview" }) > 0 then
      hl.dispatch(hl.dsp.event("expose.window-overview:toggle"))
    end
  end,
})
