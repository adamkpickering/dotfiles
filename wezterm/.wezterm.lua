-- There are a few objects that you should be familiar with:
--
-- Windows, tabs, and panes: this part is intuitive
-- Domains: about where the terminal is running physically
-- Workspaces: about the way that windows are displayed
--
-- So windows belong to BOTH domains and workspaces.
--
-- Other tips:
-- - ctrl+shift+p brings up a command palette
-- - ctrl+p is set to switch between workspaces
-- - the `local` domain is already created, so there is no need to define it
-- - the `default` workspace is automatically created
local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local local_tab, local_pane, local_window = mux.spawn_window {
    workspace = 'default',
  }
  local_window:gui_window():maximize()
end)

-- wezterm.on('mux-startup', function()
--   local rancher_tab, rancher_pane, rancher_window = mux.spawn_window {
--     cwd = '/home/adam/dev/rancher',
--     args = { 'nu' },
--     workspace = 'rancher',
--   }
-- end)

return {
  default_prog = { 'nu' },
  keys = {
    { key = 'p', mods = 'CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|LAUNCH_MENU_ITEMS|DOMAINS|WORKSPACES' } },
    -- { key = 'e', mods = 'CTRL', action = act.SwitchToWorkspace { name = 'rancher' } },
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
