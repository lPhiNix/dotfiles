local scheme = require("scheme.current")

hl.config({
    group = {
        col = {
            border_active          = "rgba(" .. scheme.primary .. "e6)",
            border_inactive        = "rgba(" .. scheme.onSurfaceVariant .. "11)",
            border_locked_active   = "rgba(" .. scheme.primary .. "e6)",
            border_locked_inactive = "rgba(" .. scheme.onSurfaceVariant .. "11)",
        },
        groupbar = {
            font_family               = "JetBrainsMono Nerd Font Mono",
            font_size                 = 15,
            gradients                 = true,
            gradient_round_only_edges = false,
            gradient_rounding         = 5,
            height                    = 25,
            indicator_height          = 0,
            gaps_in                   = 3,
            gaps_out                  = 3,
            text_color                = "rgb(" .. scheme.onPrimary .. ")",
            col                       = {
                active          = "rgba(" .. scheme.primary .. "d4)",
                inactive        = "rgba(" .. scheme.outline .. "d4)",
                locked_active   = "rgba(" .. scheme.primary .. "d4)",
                locked_inactive = "rgba(" .. scheme.secondary .. "d4)",
            },
        },
    },
})
