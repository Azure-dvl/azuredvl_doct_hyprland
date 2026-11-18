-- Auth agent
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- NetworkManager
hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet")
end)

-- Notifications
hl.on("hyprland.start", function()
    hl.exec_cmd("dunst -conf /home/azure/.config/dunst/dunstrc")
end)

-- Hyprland
hl.on("hyprland.start", function()
    hl.exec_cmd("qs & hyprpaper &")
    hl.exec_cmd("hypridle")
end)

-- Programs
hl.on("hyprland.start", function()
    hl.exec_cmd("kitty")
end)

-- Cliphboard
hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
