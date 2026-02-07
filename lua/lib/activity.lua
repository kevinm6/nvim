-------------------------------------
-- title: activity.lua
-- abstract: helper functions to show an activity indicator
-- author: Kevin
-- date: 25 Jan 2026, 19:26
-------------------------------------

local M = {}

-- Spinner frames
M.frames_preset = {
  modern_frames = {
    "⠋", "⠙", "⠹", "⠸", "⠼",
    "⠴", "⠦", "⠧", "⠇", "⠏",
  },
  ios_frames = { "◐", "◓", "◑", "◒" },
  line_frames = { "-", "\\", "|", "/" },
  arc_frames = {
    "󰫃", "󰫄", "󰫅", "󰫆",
    "󰫇", "󰫈", "󰫉", "󰫊",
  },
  classic_frames = { "⠁", "⠂", "⠄", "⠂" },
  dot_frames = { "●", "◕", "◑", "◔", "○" },
  fancy_frames = { "󰝥", "󰝦", "󰝧", "󰝨" },
  bar_frames = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
}

local index = 1
local timer = vim.uv.new_timer()

-- Active tasks
local active = {}

---Start animation loop if needed
---@param num_frames integer number of frames
local function check_timer(num_frames)
  if not timer then return end
  if timer:is_active() then return end

  timer:start(0, 100, vim.schedule_wrap(function()
      index = (index % num_frames) + 1
      vim.cmd("redrawstatus")
  end))
end

-- Stop animation if nothing is active
local function stop_timer()
  if next(active) ~= nil then return end

  if timer then timer:stop() end
  index = 1
  vim.cmd.redrawstatus()
end

---Start activity timer
---@param name string name of the activity
---@param frames string? type of frames
function M.start(name, frames)
  name = name or "task"
  M.frames = frames or M.frames_preset["modern_frames"]
  active[name] = true
  check_timer(#M.frames)
end

function M.stop(name)
  name = name or "task"
  active[name] = nil
  stop_timer()
end

function M.status()
  if not next(active) then return "" end

  local labels = vim.tbl_keys(active)
  table.sort(labels)

  return string.format(
    " %s %s ",
    M.frames[index],
    table.concat(labels, ",")
  )
end

return M