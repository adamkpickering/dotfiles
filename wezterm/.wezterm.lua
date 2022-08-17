local wezterm = require 'wezterm'
local act = wezterm.action

return {
  default_prog = { 'nu' },
  keys = {
    { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
    { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
    { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
    { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
    { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
    { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  },
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
