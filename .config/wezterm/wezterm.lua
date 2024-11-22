local wezterm = require("wezterm")
local act = wezterm.action
-- local session_manager = require("wezterm-session-manager/session-manager")

wezterm.on("save_state", function(window, pane) session_manager.save_state(window, pane) end)
wezterm.on("load_state", function() session_manager.load_state() end)
wezterm.on("restore_state", function(window) session_manager.restore_state(window) end)

wezterm.on("print_info", function(window)
  local mux = wezterm.mux
  local workspace = mux.get_active_workspace()
  local workspace2 = window:active_workspace()
  local windowid = window:window_id()
  wezterm.log_info("Workspace: " .. workspace)
  wezterm.log_info("Workspace option 2: " .. workspace2)
  wezterm.log_info("All Windows: " .. windowid)

  -- local info = string.format(
  --   "Window ID: %d, Tab ID: %d, Pane ID: %d, Workspace: %s",
  --   window:window_id(), tab:tab_id(), pane:pane_id(), workspace:name()
  -- )
  local tabs_info = window:tabs_with_info()
  local tab_details = {}

  for _, tab_info in ipairs(tabs_info) do
    local details = string.format("Tab Index: %d, Is Active: %s, Tab ID: %d",
      tab_info.index,
      tostring(tab_info.is_active),
      tab_info.tab:tab_id())
    table.insert(tab_details, details)
  end

  local tab_details_str = table.concat(tab_details, "; ")
  wezterm.log_info(string.format("Window ID: %d, Tabs Info: [%s]", window:window_id(), tab_details_str))
end)
-- Functions
local get_last_folder_segment = function(cwd)
  if cwd == nil then
    return "N/A" -- or some default value you prefer
  end

  -- Strip off 'file:///' if present
  local pathStripped = cwd:match("^file:///(.+)") or cwd
  -- Normalize backslashes to slashes for Windows paths
  pathStripped = pathStripped:gsub("\\", "/")
  -- Split the path by '/'
  local path = {}
  for segment in string.gmatch(pathStripped, "[^/]+") do
    table.insert(path, segment)
  end
  return path[#path] -- returns the last segment
end

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir or ''
  return get_last_folder_segment(current_dir)
end

local process_icons = {
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['psql'] = wezterm.nerdfonts.dev_postgresql,
  ['kuberlr'] = wezterm.nerdfonts.linux_docker,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['stern'] = wezterm.nerdfonts.linux_docker,
  ['nvim'] = wezterm.nerdfonts.custom_vim,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
  ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
  ['btm'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['htop'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['sudo'] = wezterm.nerdfonts.fa_hashtag,
  ['lazydocker'] = wezterm.nerdfonts.linux_docker,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
  ['curl'] = wezterm.nerdfonts.mdi_flattr,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
  ['pwsh'] = wezterm.nerdfonts.seti_powershell,
  ['node'] = wezterm.nerdfonts.dev_nodejs_small,
  ['dotnet'] = wezterm.nerdfonts.md_language_csharp,
}
local function get_process(tab)
  local process_name = tab.active_pane.foreground_process_name:match("([^/\\]+)%.exe$") or
      tab.active_pane.foreground_process_name:match("([^/\\]+)$")

  local icon = process_icons[process_name] or wezterm.nerdfonts.seti_checkbox_unchecked

  return icon
end

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Colorscheme
config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
--config.color_scheme = "Tokyo Night"

-- Font
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "IbmPlex",
  -- "OperatorMono",
  -- "MapleMono",
  -- "VictorMono NF"
}
config.font_size = 11.0

-- Monaspace:  https://monaspace.githubnext.com/
-- Based upon, contributed to:  https://gist.github.com/ErebusBat/9744f25f3735c1e0491f6ef7f3a9ddc3
config.font = wezterm.font(
  { -- Normal text
    family = 'Monaspace Neon',
    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
    stretch = 'UltraCondensed', -- This doesn't seem to do anything
  })

config.font_rules = {
  { -- Italic
    intensity = 'Normal',
    italic = true,
    font = wezterm.font({
      -- family = "Monaspace Radon", -- script style
      family = 'Monaspace Xenon', -- courier-like
      style = 'Italic',
    })
  },

  { -- Bold
    intensity = 'Bold',
    italic = false,
    font = wezterm.font({
      family = 'Monaspace Krypton',
      -- weight='ExtraBold',
      weight = 'Bold',
    })
  },

  { -- Bold Italic
    intensity = 'Bold',
    italic = true,
    font = wezterm.font({
      family = 'Monaspace Xenon',
      -- family = "Monaspace Radon",
      style = 'Italic',
      weight = 'Bold',
    }
    )
  },
}

-- From: https://stackoverflow.com/a/7470789/5353461
function merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      merge_tables(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

-- config = merge_tables(config, font_config)

-- Window
config.window_background_opacity = 0.9
-- config.window_decorations = "RESIZE" -- removes close, minimize and so on
config.window_close_confirmation = "AlwaysPrompt"
config.window_padding = {
  top = 5,
  right = 5,
  bottom = 0,
  left = 5,
}

-- General
config.scrollback_lines = 3000
config.default_prog = { "/bin/bash" }

--
-- Hyperlinks
--

-- https://wezfurlong.org/wezterm/hyperlinks.html

-- Terminal hyperlinks
-- https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
-- printf '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'

-- Use the defaults as a base.  https://wezfurlong.org/wezterm/config/lua/config/hyperlink_rules.html
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)

-- Regex syntax:  https://docs.rs/regex/latest/regex/#syntax and https://docs.rs/fancy-regex/latest/fancy_regex/#syntax
-- Lua's [[ ]] literal strings prevent character [[:classes:]] :(
-- To avoid "]]] at end, use "[a-z].{0}]]"
-- https://www.lua.org/pil/2.4.html#:~:text=bracketed%20form%20may%20run%20for%20several%20lines%2C%20may%20nest

table.insert(config.hyperlink_rules, {
  -- https://github.com/shinnn/github-username-regex  https://stackoverflow.com/a/64147124/5353461
  regex = [[(^|(?<=[\[(\s'"]))([0-9A-Za-z][-0-9A-Za-z]{0,38})/([A-Za-z0-9_.-]{1,100})((?=[])\s'".!?])|$)]],
  --  is/good  0valid0/-_.reponname  /bad/start  -bad/username  bad/end!  too/many/parts -bad/username
  --  [wraped/name] (aa/bb) 'aa/bb' "aa/bb"  end/punct!  end/punct.
  format = 'https://www.github.com/$2/$3/',
  -- highlight = 0,  -- highlight this regex match group, use 0 for all
})


-- Tab/Status Bar
-- disables the 'modern' look of the tab bar
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.status_update_interval = 1000
config.tab_max_width = 60
config.tab_bar_at_bottom = false
wezterm.on('format-tab-title', function(tab)
  local has_unseen_output = false
  local is_zoomed = false
  for _, pane in ipairs(tab.panes) do
    if pane.has_unseen_output then
      has_unseen_output = true
    end
    if pane.is_zoomed then
      is_zoomed = true
    end
  end

  local cwd = get_current_working_dir(tab)
  local process = get_process(tab)
  local zoom_icon = is_zoomed and wezterm.nerdfonts.cod_zoom_in or ""
  local title = string.format(' %s  %s %s ', process, cwd, zoom_icon)

  local formatted_title = wezterm.format({
    { Attribute = { Intensity = 'Bold' } },
    { Text = title }
  })

  if has_unseen_output then
    return {
      { Foreground = { Color = '#28719c' } },
      { Text = formatted_title }
    }
  else
    return {
      { Text = formatted_title }
    }
  end
end
)
wezterm.on("update-status", function(window, pane)
  local workspace_or_leader = window:active_workspace()
  if window:active_key_table() then workspace_or_leader = window:active_key_table() end
  if window:leader_is_active() then workspace_or_leader = "LEADER" end

  local cmd = get_last_folder_segment(pane:get_foreground_process_name())
  local time = wezterm.strftime("%H:%M")
  local hostname = " " .. wezterm.hostname() .. " ";

  window:set_right_status(wezterm.format({
    { Text = wezterm.nerdfonts.oct_table .. " " .. workspace_or_leader },
    { Text = " | " },
    { Foreground = { Color = "FFB86C" } },
    { Text = wezterm.nerdfonts.fa_code .. " " .. cmd },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.oct_person .. " " .. hostname },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. " " .. time },
    { Text = " | " },
  }))
end)

-- Panes
config.inactive_pane_hsb = {
  saturation = 0.4,
  brightness = 0.5
}

-- Keys
config.leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 3000 }
config.keys = {
  { key = "C", mods = "LEADER", action = act.ActivateCopyMode },

  -- Pane Keybindings
  { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "|", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "s", mods = "LEADER", action = act.RotatePanes "Clockwise" },
  { key = "r", mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab Keybindings
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "t", mods = "LEADER", action = act.ShowTabNavigator },
  -- Table for moving tabs around
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },

  -- Workspace
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
  {
    key = 'W',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },

  -- Session Manager
  { key = "S", mods = "LEADER", action = wezterm.action({ EmitEvent = "save_state" }) },
  { key = "R", mods = "LEADER", action = wezterm.action({ EmitEvent = "restore_state" }) },
  { key = "L", mods = "LEADER", action = wezterm.action({ EmitEvent = "load_state" }) },
}

-- Quick tab movement
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "j",      action = act.MoveTabRelative(-1) },
    { key = "k",      action = act.MoveTabRelative(1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  }
}

return config
