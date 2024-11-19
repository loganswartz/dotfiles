-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.window_background_opacity = 0.85
-- config.text_background_opacity = 0.80

config.font = wezterm.font_with_fallback {
    'Mononoki Nerd Font Mono',
    'JetBrains Mono',
}
config.font_size = 13.0
config.hide_tab_bar_if_only_one_tab = true
-- config.tab_bar_at_bottom = true

-- config.window_frame = {
--     inactive_titlebar_bg = "none",
--     active_titlebar_bg = "none",
-- }

config.color_schemes = {
    ['Sunburn'] = {
        foreground = "#9c9c9c",
        background = "#181818",

        -- Overrides the cell background color when the current cell is occupied by the
        -- cursor and the cursor style is set to Block
        -- cursor_bg = '#52ad70',
        -- -- Overrides the text color when the current cell is occupied by the cursor
        -- cursor_fg = 'black',
        -- -- Specifies the border color of the cursor when the cursor style is set to Block,
        -- -- or the color of the vertical or horizontal bar when the cursor style is set to
        -- -- Bar or Underline.
        -- cursor_border = '#52ad70',
        --
        -- -- the foreground color of selected text
        -- selection_fg = 'black',
        -- -- the background color of selected text
        -- selection_bg = '#fffacd',
        --
        -- -- The color of the scrollbar "thumb"; the portion that represents the current viewport
        -- scrollbar_thumb = '#222222',
        --
        -- -- The color of the split lines between panes
        -- split = '#444444',

        ansi = {
            "#181818",
            "#ca736d",
            "#49a478",
            "#8d9742",
            "#5894d0",
            "#9481cb",
            "#08a2af",
            "#b8b8b8",
        },
        brights = {
            "#292929",
            "#f59a92",
            "#72cc9e",
            "#b4bf6a",
            "#7ebbfa",
            "#bba8f5",
            "#4dcad7",
            "#dedede",
        },
    }
}

config.color_scheme = 'Sunburn'

-- and finally, return the configuration to wezterm
return config
