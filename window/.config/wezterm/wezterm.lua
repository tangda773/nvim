local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_prog = { "pwsh", "-NoLogo" }
-- config.color_scheme = "Batman"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 999
config.font_size=24
config.font=wezterm.font_with_fallback{"Cascadia Mono","STIX Two Math","Noto Color Emoji", "MS Gothic"}
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

local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)

  -- directional keys to use in order of: left, down, up, right
  -- direction_keys = { 'h', 'j', 'k', 'l' },
  -- if you want to use separate direction keys for move vs. resize, you
  -- can also do this:
  direction_keys = {
    move = { 'h', 'j', 'k', 'l' },
    resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'META', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})


return config
