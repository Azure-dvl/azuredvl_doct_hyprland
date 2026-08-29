-- Evironment variables

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- Editor
hl.env("EDITOR", "vim")
hl.env("TERMINAL", "kitty")

-- Cursor
hl.env("XCURSOR_SIZE", "14")
hl.env("XCURSOR_THEME", var_cursor)
hl.env("HYPRCURSOR_SIZE", "14")
hl.env("HYPRCURSOR_THEME", var_cursor)

-- GTK
hl.env("GTK_THEME", var_theme)
hl.env("GTK_ICON_THEME", var_icons)
hl.env("GTK_FONT", var_font)
hl.env("GDK_BACKEND", "wayland")
hl.env("GDK_SCALE", "1")
