local fn = require("utils.functions")

hl.on("hyprland.start", function()
    -- Keyring and auth
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("command -v hyprpolkitagent >/dev/null && hyprpolkitagent")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto delete trash 30 days old
    hl.exec_cmd("trash-empty 30")

    -- Cursors
    hl.exec_cmd("hyprctl setcursor breeze_cursors 24")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme breeze_cursors")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")

    -- Night light (manual coordinates: Madrid)
    hl.exec_cmd("gammastep -l 40.4168:-3.7038")

    -- Forward bluetooth media commands to MPRIS
    hl.exec_cmd("mpris-proxy")

    -- Ensure the shell has an initial colour scheme
    hl.exec_cmd("test -f \"$HOME/.local/state/caelestia/scheme.json\" || caelestia scheme set -n caelestia")

    -- Start shell
    hl.exec_cmd("caelestia shell -d")
end)

-- Resizer listeners
local function apply_resizer_rules(win)
    local pip_actions = fn.move_actions(win) or {}

    -- Picture in picture
    fn.resizer(win, "Picture[- ]in[- ][Pp]icture", 0, 0, pip_actions, false)
end

hl.on("window.title", apply_resizer_rules)
hl.on("window.open", apply_resizer_rules)
