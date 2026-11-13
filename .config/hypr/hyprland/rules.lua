-- Tags an array of window matches. If `field` is given, matches should be an
-- array of strings. Otherwise, it should be an array of tables.
local function tagged_rule(tag, matches, field)
    for _, match in ipairs(matches) do
        if field then
            local table = {}
            table[field] = match
            match = table
        end
        hl.window_rule({ match = match, tag = "+" .. tag })
    end
end

local function create_tag(tag, rules)
    local rule = { match = { tag = tag } }
    for k, v in pairs(rules) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

-- All tags
local opaque_tag = "opaque"
local float_tag = "float"
local float_60_70_tag = "float_60_70"
local game_tag = "game"
local xwl_popup_tag = "xwl_popup"
local system_monitor_tag = "system_monitor"


----------------------
---- Window rules ----
----------------------

-- Apply default opacity to all windows except fullscreen
hl.window_rule({ match = { fullscreen = false }, opacity = "0.95 override" })

-- Center all floating windows except xwayland windows
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

-- Picture in picture (move and resize done via resizer in execs.lua)
hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)",
    pin               = true,
    float             = true,
    keep_aspect_ratio = true,
})


----------------------
---- Tagged rules ----
----------------------

-- Opaque apps
tagged_rule(opaque_tag, {
    "kitty",
    "org.quickshell",
    "gimp|inkscape",
    "kdenlive",
    "mpv|celluloid",
}, "class")


-- Floating apps
tagged_rule(float_tag, {
    "org.quickshell",
}, "class")
tagged_rule(float_tag, {
    "File (Operation|Upload)( Progress)?",
    ".* Properties",
    'Rename ".*"',
}, "title")


-- Sized floaters: 60% x 70%
tagged_rule(float_60_70_tag, {
    "(Select|Open)( a)? (File|Folder)(s)?",
    "Save As",
}, "title")
tagged_rule(float_60_70_tag, {
    { title = "(Save|Export) Image", class = "gimp" },
})
tagged_rule(float_60_70_tag, {
    "org.pulseaudio.pavucontrol|com.saivert.pwvucontrol",
}, "class")


-- Games
tagged_rule(game_tag, {
    "steam_app_[0-9]+",
    "steam_app_default",
    "gamescope",
}, "class")


-- Xwayland popups
tagged_rule(xwl_popup_tag, {
    { xwayland = true, title = "win[0-9]+" },
    { xwayland = true, title = "", class = "", initial_title = "", initial_class = "" },
})


-- Special workspaces
tagged_rule(system_monitor_tag, { "btop" }, "class")


-----------------------
---- Per app rules ----
-----------------------

-- Steam
tagged_rule(float_tag, { { class = "steam", title = "Friends List" } })
tagged_rule(xwl_popup_tag, { { class = "steam", title = "" } })

-- Minecraft launcher consoles
tagged_rule(float_tag, {
    { class = "com-atlauncher-App", title = "ATLauncher Console" },
})


-------------------------
---- Tag definitions ----
-------------------------
-- These have to come after all uses of window tagging.

create_tag(opaque_tag, { opaque = true })
create_tag(float_tag, { float = true })
create_tag(float_60_70_tag, { float = true, size = "(monitor_w*0.6) (monitor_h*0.7)", center = true })
create_tag(game_tag, { opaque = true, immediate = true, idle_inhibit = "always" })
create_tag(xwl_popup_tag, {
    no_dim = true,
    no_shadow = true,
    no_blur = true,
    opaque = true,
    rounding = 8, -- Popups are usually small, so limit the rounding
})
create_tag(system_monitor_tag, { workspace = "special:sysmon" })


-------------------------
---- Workspace rules ----
-------------------------

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 20 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 20 })


---------------------
---- Layer rules ----
---------------------

hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" })

-- Shell
hl.layer_rule({ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true })
hl.layer_rule({ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" })
