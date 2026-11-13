local scheme = require("scheme.current")

hl.config({
    decoration = {
        rounding = 8,

        blur = {
            enabled           = true,
            xray              = false,
            special           = false,
            ignore_opacity    = true, -- Allows opacity blurring
            new_optimizations = true,
            popups            = true,
            input_methods     = true,
            size              = 8,
            passes            = 2,
        },

        shadow = {
            enabled      = true,
            range        = 15,
            render_power = 4,
            color        = "rgba(" .. scheme.inversePrimary .. "10)",
        },
    },
})
