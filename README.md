# Run Timer

A [Kindle](#kindle) mod for Dark Souls III (version 1.15.2).

A speedrun clock across the screen, with a split each time a boss falls and (if you like) the
first time you rest at each bonfire. Each split is compared with your best time for it: green when
you're ahead, red when you're behind.

## Using it

Load a character and the clock starts at 0:00. It counts the game's own play time, so it stops in
the title screen and carries on where it was when you load again.

- **Splits.** A boss's "Heir of Fire Destroyed" or "Lord of Cinder Fallen" banner makes a split.
  With **Split at bonfires** on, so does the first rest at each bonfire in the run. A message shows
  the split's time and the difference from your best.
- **The Run timer tab.** In the pause menu, choose **Mods**, then **Run timer**: the run's last 12
  splits, **Restart the clock** (a new run from now; best times are kept) and **Forget best
  times**.

The run belongs to the character; best times are yours, shared by every character.

## Settings

In the game (**Mods**, the **Kindle** tab, **All mod settings**, then Run Timer) or in Kindle
Launcher while the game is closed:

- **Show the clock** (on): the time across the screen. Splits still count with it off.
- **Split at bonfires** (on): a split at the first rest at each bonfire, as well as at bosses.

## Installing it

Install Kindle first ([khaelemw/kindle](https://github.com/khaelemw/kindle)). Then download `run-timer.zip` from this repo's Releases and unzip it into the game's `Game\kindle\mods` folder, so you have `Game\kindle\mods\run-timer\mod.toml`.

The Run Timer is off until you switch it on: at the title screen or in the
pause menu, choose **Mods**, open the **Mods** tab and turn **Run Timer** on. It starts at once.
Kindle Launcher's mod list does the same while the game is closed.

## Removing it

Switch it off in **Mods**, or delete `Game\kindle\mods\run-timer`. It changes nothing in the game:
it only shows a clock and keeps its times.

## Kindle

Kindle is a Lua modding runtime for Dark Souls III: mods are folders of Lua scripts, switched on
and off in game. This mod is plain Lua in `main.lua`; edit it with the game running and Kindle
reloads it when you save. For modders, Kindle's docs build it step by step (Mod tours, tour 2),
and its `examples\ex-run-timer` explains how it works.
