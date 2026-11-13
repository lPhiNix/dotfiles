local scheme = require("scheme.current")

hl.config({
    general = {
        layout          = "dwindle",

        allow_tearing   = false, -- Allows `immediate` window rule to work

        gaps_workspaces = 20,
        gaps_in         = 5,
        gaps_out        = 10,
        border_size     = 3,

        col             = {
            active_border   = "rgba(" .. scheme.primary .. "e6)",
            inactive_border = "rgba(" .. scheme.onSurfaceVariant .. "11)",
        },
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
        smart_resizing = true,
    },

    scrolling = {
        fullscreen_on_one_column = true,
        focus_fit_method         = 1,
        column_width             = 0.5,
        follow_focus             = true,
        follow_min_visible       = 0.0,
        explicit_column_widths   = "0.35, 0.5, 0.65, 1.0",
    },
})
