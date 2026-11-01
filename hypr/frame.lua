-- 6px frame on the focused window only, in the theme's bright magenta.
-- Unfocused windows draw no border.
local function theme_hex(key)
  local state = os.getenv("XDG_STATE_HOME")
  if not state or state == "" then
    state = (os.getenv("HOME") or "") .. "/.local/state"
  end

  local file = io.open(state .. "/omarchy/current/theme/colors.toml", "r")
  if not file then
    return nil
  end

  for line in file:lines() do
    local hex = line:match("^" .. key .. "%s*=%s*\"(#%x%x%x%x%x%x)\"")
    if hex then
      file:close()
      return hex
    end
  end

  file:close()
  return nil
end

local bright = theme_hex("bright_magenta") or "#bb9af7"
local purple = "rgb(" .. bright:sub(2) .. ")"

hl.config({
  general = {
    border_size = 6,

    col = {
      active_border = purple,
      inactive_border = "rgba(00000000)",
    },
  },

  group = {
    col = {
      border_active = purple,
      border_inactive = "rgba(00000000)",
    },
  },
})

o.window({ focus = false }, { border_size = 0 })
