hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = {
                colors = {"rgba(89b4faff)", "rgba(181825ff)", "rgba(181825ff)", "rgba(89b4faff)"},
                angle = 20,
            },
            inactive_border = {
                colors = {"rgba(313244ff)", "rgba(313244ff)", "rgba(313244ff)", "rgba(45475aff)"},
                angle = 90,
            },
        },
        resize_on_border = true,
        extend_border_grab_area = 30,
        hover_icon_on_border = true,
        resize_corner = 4,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        blur = {
            noise = 0.01,
            passes = 2,
            size = 2,
        },
        rounding = 20,
        dim_special = 0.2,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        shadow = {
            enabled = false,
            range = 1,
            render_power = 1,
            color = "rgba(00d4ff33)",
            offset = "0 1",
        },
    },
})

require("appearence.theme.colors")

-- ignore_window = true
hl.config({
    decoration = {
        blur = {
            enabled = true,
            size = 2,
            popups = true,
            passes = 2,
            new_optimizations = true,
            vibrancy = 0.5,
            ignore_opacity = true,
            special = true,
        },
    },
})

-- pseudotile = false # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
hl.config({
    dwindle = {
        preserve_split = true,
        force_split = 2,
        smart_split = false,
    },
    master = {
        orientation = "center",
        slave_count_for_center_master = 0,
        always_keep_position = false,
        smart_resizing = false,
        drop_at_cursor = false,
        mfact = 0.5,
    },
    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo = true,
        animate_manual_resizes = true,
    },
})
