local var_main = "SUPER"
local var_mod = "SHIFT"

require("programs")

-- Aplications
hl.bind(var_main .. " + E", hl.dsp.exec_cmd(var_fileManager))
hl.bind(var_main .. " + T", hl.dsp.exec_cmd(var_terminal))
hl.bind(var_main .. " + M", hl.dsp.exec_cmd(var_menu))
hl.bind(var_main .. " + N", hl.dsp.exec_cmd(var_navegador))
hl.bind(var_main .. " + C", hl.dsp.exec_cmd("kitty cava"))
hl.bind(var_main .. " + O", hl.dsp.exec_cmd("kitty opencode"))
hl.bind(var_main .. " + H", hl.dsp.exec_cmd("kitty tty-clock -c -C 4"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grimblast --notify copy output"))
hl.bind(var_mod .. " + Print", hl.dsp.exec_cmd("grimblast --notify --freeze copy area"))

-- LockScreen
hl.bind(var_main .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(var_main .. " + " .. var_mod .. " + L", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- System
hl.bind(var_main .. " + Q", hl.dsp.window.close())
hl.bind(var_main .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(var_main .. " + F", hl.dsp.window.fullscreen())
hl.bind(var_main .. " + P", hl.dsp.window.pseudo())

-- Move focus
hl.bind(var_main .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(var_main .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(var_main .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(var_main .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces
hl.bind(var_main .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(var_main .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(var_main .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(var_main .. " + 4", hl.dsp.focus({ workspace = 4 }))

-- Move active window to a workspace with main + SHIFT + [0-9]
hl.bind(var_main .. " + " .. var_mod .. " + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(var_main .. " + " .. var_mod .. " + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(var_main .. " + " .. var_mod .. " + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(var_main .. " + " .. var_mod .. " + 4", hl.dsp.window.move({ workspace = 4 }))

-- Scroll through existing workspaces with main + scroll
hl.bind(var_main .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(var_main .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main + LMB/RMB and dragging
hl.bind(var_main .. " + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
})
hl.bind(var_main .. " + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
})
