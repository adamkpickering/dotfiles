local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'F1', action = act.ActivateTab(0) },
    { key = 'F2', action = act.ActivateTab(1) },
    { key = 'F3', action = act.ActivateTab(2) },
    { key = 'F4', action = act.ActivateTab(3) },
    { key = 'F5', action = act.ActivateTab(4) },
    { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  },
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
