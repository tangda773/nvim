local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_prog = { "pwsh", "-NoLogo" }
-- config.color_scheme = "Batman"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 999
config.font_size=24
config.font=wezterm.font_with_fallback{"Cascadia Mono","STIX Two Math","Noto Color Emoji"}
config.window_decorations="RESIZE"

-- config.window_background_opacity=0.8

function get_max_cols(window)
  local tab = window:active_tab()
  local cols = tab:get_size().cols
  return cols
end

wezterm.on(
  'window-config-reloaded',
  function(window)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'window-resized',
  function(window, pane)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = tab.active_pane.title
    local full_title = '[' .. tab.tab_index + 1 .. '] ' .. title
    local pad_length = (wezterm.GLOBAL.cols // #tabs - #full_title) // 2
    if pad_length * 2 + #full_title > max_width then
      pad_length = (max_width - #full_title) // 2
    end
    return string.rep(' ', pad_length) .. full_title .. string.rep(' ', pad_length)
  end
)

local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- ssh_cmd = { "powershell.exe" }

  table.insert(launch_menu, {
    label = "PowerShell",
    args = { "powershell.exe", "-NoLogo" },
  })

  table.insert(launch_menu, {
    label = "CMD",
    args = { "cmd.exe" },
  })
end

config.tab_bar_at_bottom = true

config.launch_menu = launch_menu

config.leader = {key = 'a',mods="CTRL", timeout_milliseconds=1000}

config.keys = {

  { key = "m", mods = "LEADER", action = wezterm.action.ShowLauncher },
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' }, -- Ctrl+a, Ctrl+a 傳遞 Ctrl+a
  },
}

return config
