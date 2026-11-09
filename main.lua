-- Run Timer. A speedrun clock on screen, with splits when a boss falls and (if switched
-- on) the first rest at each bonfire. Each split is compared with the best time for it, kept
-- across characters, and the Mods screen has a tab with the run's splits and a reset.
-- Teaches: the game's play time as a clock, ui.status updated by a timer, boss_defeated and
-- bonfire_rested, the store per character and the global store, a mod_tab rebuilt as things change.

local BOSS_SPLITS = { heir_of_fire = "Heir of fire destroyed", lord_of_cinder = "Lord of cinder fallen" }
local SPLITS_SHOWN = 12 -- the tab has room for 16 rows: splits, then the buttons

-- The run of the loaded character: {start = play time at the start, splits = {{name =, time =}}}.
local run = nil

local function clock(seconds)
  seconds = math.floor(seconds)
  local hours, minutes = seconds // 3600, seconds % 3600 // 60
  if hours > 0 then
    return string.format("%d:%02d:%02d", hours, minutes, seconds % 60)
  end
  return string.format("%d:%02d", minutes, seconds % 60)
end

local function elapsed()
  return kindle.player.play_time() - run.start
end

local function save()
  kindle.store.set("run", run)
end

local show_tab -- defined below; the reset button calls it

local function start_run()
  run = { start = kindle.player.play_time(), splits = {} }
  save()
  show_tab()
end

function show_tab()
  local rows = {}
  local first = math.max(1, #run.splits - SPLITS_SHOWN + 1)
  for index = first, #run.splits do
    local split = run.splits[index]
    rows[#rows + 1] = { label = string.format("%s  %s", clock(split.time), split.name), info = true }
  end
  if #rows == 0 then
    rows[1] = { label = "No splits yet", info = true }
  end
  rows[#rows + 1] = { label = "Restart the clock", help = "Starts the run again from now; best times are kept.", on_press = start_run }
  rows[#rows + 1] = {
    label = "Forget best times",
    help = "Clears the best time of every split, for every character.",
    on_press = function()
      kindle.store.set_global("best", {})
      kindle.ui.toast("Best times cleared")
    end,
  }
  kindle.ui.mod_tab("Run timer", rows)
end

local function split(name)
  if not run then
    return
  end
  local time = elapsed()
  run.splits[#run.splits + 1] = { name = name, time = time }
  save()
  local best = kindle.store.get_global("best", {})
  local previous = best[name]
  if previous then
    local difference = time - previous
    local sign = difference <= 0 and "-" or "+"
    kindle.ui.toast(string.format("%s  %s (%s%s)", name, clock(time), sign, clock(math.abs(difference))),
      { color = difference <= 0 and "green" or "red" })
  else
    kindle.ui.toast(string.format("%s  %s", name, clock(time)))
  end
  if not previous or time < previous then
    best[name] = time
    kindle.store.set_global("best", best)
  end
  show_tab()
end

kindle.on("player_loaded", function()
  run = kindle.store.get("run")
  if not run then
    start_run()
  end
  show_tab()
end)

kindle.on("player_unloaded", function()
  run = nil
  kindle.ui.status(nil)
end)

-- The clock: the game's own play time, which the save keeps, so a run goes on across quitting.
kindle.every(0.5, function()
  if run and kindle.settings.get("show_clock") then
    kindle.ui.status(clock(elapsed()))
  end
end)

kindle.on("setting_changed", function(name, value)
  if name == "show_clock" and not value then
    kindle.ui.status(nil)
  end
end)

kindle.on("boss_defeated", function(kind)
  split(BOSS_SPLITS[kind] or kind)
end)

kindle.on("bonfire_rested", function(bonfire)
  if not (bonfire and bonfire.name and kindle.settings.get("split_on_bonfires") and run) then
    return
  end
  local name = "Bonfire: " .. bonfire.name
  for _, earlier in ipairs(run.splits) do
    if earlier.name == name then
      return -- a split for a bonfire's first rest only
    end
  end
  split(name)
end)
