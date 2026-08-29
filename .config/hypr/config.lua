hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
})

require("config.env")
require("config.monitors")
require("config.input")
