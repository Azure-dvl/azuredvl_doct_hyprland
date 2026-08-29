-- # Hyprland Config

-- Window and theme
require("theme")
require("config")

-- Keybind
require("keybind")

-- Autostart
require("autostart")

-- Rule
hl.config({
    ecosystem = {
        no_update_news = true,
    },
})

require("window_rule")

-- HyprMod managed settings
require("hyprland-gui")
