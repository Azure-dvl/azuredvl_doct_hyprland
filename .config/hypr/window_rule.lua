-- Default

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
hl.window_rule({
    name = "move-hyprland-run",
    match = {
        class = "hyprland-run",
    },
    move = "20 monitor_h-120",
    float = true,
})

-- Reglas para ventanas de diálogo de Thunar

-- 1. Progreso de operaciones de archivos (Copiar, Mover, Eliminar)
hl.window_rule({
    name = "thunar-file-operation",
    match = {
        class = "^(thunar)$",
        title = "^(File Operation Progress)$"
    },
    float = true,
    size = "500 300",  -- Ajusta el tamaño a tu gusto
    center = true
})

-- 2. Diálogo de Renombrar
hl.window_rule({
    name = "thunar-rename",
    match = {
        class = "^(thunar)$",
        title = "^(Rename.*)$"  -- Coincide con "Rename", "Rename 3 files", etc.
    },
    float = true,
    size = "500 200",
    center = true
})

-- 3. Diálogo de confirmación (Reemplazar archivos, Atención, etc.)
hl.window_rule({
    name = "thunar-confirm",
    match = {
        class = "^(thunar)$",
        title = "^(Confirm to replace files|Attention)$"
    },
    float = true,
    size = "550 250",
    center = true
})

-- 4. Diálogo de Propiedades
hl.window_rule({
    name = "thunar-properties",
    match = {
        class = "^(thunar)$",
        title = "^(.*Properties)$"
    },
    float = true,
    size = "600 500",
    center = true
})

-- 5. Diálogo de Crear Nuevo (Carpeta/Documento)
hl.window_rule({
    name = "thunar-create",
    match = {
        class = "^(thunar)$",
        title = "^(Create.*)$"
    },
    float = true,
    size = "500 250",
    center = true
})

-- 6. Diálogo de Papelera y Autenticación
hl.window_rule({
    name = "thunar-trash-auth",
    match = {
        class = "^(thunar)$",
        title = "^(Trash|Authentication)$"
    },
    float = true,
    size = "500 200",
    center = true
})

-- Etiquetas
hl.window_rule({
    match = {
        class = "^(kitty)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(thunar)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(org.telegram.desktop)$",
    },
    tag = "+chat",
})
hl.window_rule({
    match = {
        class = "^(discord)$",
    },
    tag = "+chat",
})
hl.window_rule({
    match = {
        class = "^(code)$",
    },
    tag = "+code",
})
hl.window_rule({
    match = {
        class = "^(jetbrains-studio)$",
    },
    tag = "+code",
})
hl.window_rule({
    match = {
        class = "^(org.xfce.mousepad)$",
    },
    tag = "+code",
})
hl.window_rule({
    match = {
        class = "^(org.gnome.Rhythmbox3)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(mpv)$",
    },
    tag = "+video",
})
hl.window_rule({
    match = {
        class = "^(org.pulseaudio.pavucontrol)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(blueman-manager)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(protonvpn-app)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(fsearch)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(org.xfce.ristretto)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(xdm-app)$",
    },
    tag = "+common",
})
hl.window_rule({
    match = {
        class = "^(firefox)$",
    },
    tag = "+browser",
})
hl.window_rule({
    match = {
        class = "^(net.lutris.Lutris)$",
    },
    tag = "+game",
})
hl.window_rule({
    match = {
        class = "^(steam)$",
    },
    tag = "+game",
})
hl.window_rule({
    match = {
        class = "^(com.github.neithern.g4music)$",
    },
    tag = "+music",
})

-- Reglas
hl.window_rule({
    name = "Browser",
    match = {
        tag = "browser",
    },
    -- monitor = 1,
})
hl.window_rule({
    name = "Chat",
    match = {
        tag = "chat",
    },
    -- monitor = 1,
    -- opacity = 0.9,
})
hl.window_rule({
    name = "Code",
    match = {
        tag = "code",
    },
    -- monitor = 1,
    opacity = 0.9,
})
hl.window_rule({
    name = "Video",
    match = {
        tag = "video",
    },
    fullscreen = true,
    -- monitor = 1,
    float = true,
})
hl.window_rule({
    name = "Common",
    match = {
        tag = "common",
    },
    -- monitor = 0,
    opacity = 0.9,
})
hl.window_rule({
    name = "Music",
    match = {
        tag = "music",
    },
    -- monitor = 0,
    opacity = 0.9,
})
hl.window_rule({
    name = "Games",
    match = {
        tag = "game",
    },
    -- monitor = 1,
})
hl.window_rule({
    name = "scrcpy",
    match = {
        class = "scrcpy",
    },
    float = true,
    -- monitor = 0,
})
