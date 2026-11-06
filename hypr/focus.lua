-- Floating workspaces focus on click, and Hyprland leaves keyboard focus on
-- whichever window is at the back of the stack. A click on the one in front
-- then does nothing. Focus the window under the pointer, and raise it.

local top_rank = {}
local top_next = 0
local raising = false

local function promote(window)
  if not window or not window.address then
    return
  end
  top_next = top_next + 1
  top_rank[window.address] = top_next
end

local function component(value, index, key)
  if type(value) ~= "table" then
    return nil
  end
  if value[index] ~= nil then
    return value[index]
  end
  return value[key]
end

local function contains(window, x, y)
  local left = component(window.at, 1, "x")
  local top = component(window.at, 2, "y")
  local width = component(window.size, 1, "x")
  local height = component(window.size, 2, "y")
  if not left or not top or not width or not height then
    return false
  end
  return x >= left and y >= top and x < left + width and y < top + height
end

local function area(window)
  local width = component(window.size, 1, "x") or 0
  local height = component(window.size, 2, "y") or 0
  return width * height
end

local function same_workspace(window, workspace)
  return window.workspace and workspace and window.workspace.id == workspace.id
end

-- A floating window that is not maximized is drawn above a maximized one.
-- Several of those can overlap; the one most recently brought forward wins,
-- and a window we have not ordered yet loses to a smaller one on top of a
-- large window behind it.
local function window_under_pointer()
  local cursor = hl.get_cursor_pos()
  if not cursor or not cursor.x or not cursor.y then
    return nil
  end

  local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
  if not workspace then
    return nil
  end

  local front, front_rank, front_area
  local behind
  for _, window in ipairs(hl.get_windows()) do
    if window.mapped ~= false and window.hidden ~= true and same_workspace(window, workspace) and contains(window, cursor.x, cursor.y) then
      if window.floating and (window.fullscreen or 0) == 0 then
        local rank = top_rank[window.address] or 0
        local window_area = area(window)
        if not front or rank > front_rank or (rank == front_rank and window_area < front_area) then
          front = window
          front_rank = rank
          front_area = window_area
        end
      elseif not behind then
        behind = window
      end
    end
  end

  return front or behind
end

local function raise(window)
  if raising or not window or not window.floating or not window.address then
    return
  end
  raising = true
  promote(window)
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top", window = window }))
  raising = false
end

-- A maximized window keeps the focus that belongs to the window in front of it.
local function release_other_maximized(window)
  local workspace = window.workspace
  if not workspace or not workspace.id or (window.fullscreen or 0) ~= 0 then
    return
  end
  local others = hl.get_workspace_windows(tostring(workspace.id)) or {}
  for _, other in ipairs(others) do
    if other.address ~= window.address and (other.fullscreen or 0) == 1 then
      hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "unset", window = other }))
    end
  end
end

hl.on("window.active", function(window)
  if not window then
    return
  end
  promote(window)
  release_other_maximized(window)
  raise(window)
end)

-- A layer surface is not a window. NittyGriddy covers the screen, so the
-- window under the pointer is the one behind the card. Focusing that window
-- consumes the click and the card never sees it.
local function layer_contains(layer, x, y)
  if not layer or layer.mapped == false then
    return false
  end
  local left = tonumber(layer.x)
  local top = tonumber(layer.y)
  local width = tonumber(layer.w)
  local height = tonumber(layer.h)
  if not left or not top or not width or not height then
    return false
  end
  return x >= left and y >= top and x < left + width and y < top + height
end

local function nitty_griddy_under_pointer()
  local cursor = hl.get_cursor_pos()
  if not cursor or not cursor.x or not cursor.y then
    return false
  end
  local layers = hl.get_layers({ namespace = "timsonner-nitty-griddy" })
  if not layers then
    return false
  end
  for _, layer in ipairs(layers) do
    if layer_contains(layer, cursor.x, cursor.y) then
      return true
    end
  end
  return false
end

hl.bind("mouse:272", function()
  if nitty_griddy_under_pointer() then
    return { ok = false }
  end

  local target = window_under_pointer()
  if not target then
    return { ok = false }
  end

  local active = hl.get_active_window()
  if active and active.address == target.address then
    raise(target)
    return { ok = false }
  end

  release_other_maximized(target)
  hl.dispatch(hl.dsp.focus({ window = target }))
  raise(target)
end, { auto_consuming = true })
