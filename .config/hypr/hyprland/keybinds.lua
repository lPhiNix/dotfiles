local fn = require("utils.functions")

-- Apps
local terminal       = "kitty"
local browser        = "brave"
local editor         = "code"
local fileExplorer   = "nautilus"
local audioSettings  = "pwvucontrol"

-- Flags
local locked           = { locked = true }
local mouse            = { mouse = true }
local release          = { release = true }
local repeating        = { repeating = true }
local locked_repeating = { locked = true, repeating = true }

local function normalise_keybind(key)
    return key:gsub("%s+", ""):lower()
end

local function valid_keybind(key)
    return type(key) == "string" and key:match("%S") ~= nil
end

local function repeating_unless_mouse(key)
    return not normalise_keybind(key):find("mouse", 1, true) and repeating or nil
end

local function flatten_keybinds(keybinds, keys)
    keys = keys or {}

    if type(keybinds) == "table" then
        for _, keybind in pairs(keybinds) do
            flatten_keybinds(keybind, keys)
        end
    elseif valid_keybind(keybinds) then
        keys[#keys + 1] = keybinds
    end

    return keys
end

local function create_bind(keybinds, action, flags)
    local get_flags = type(flags) == "function" and flags or function()
        return flags
    end

    for _, key in ipairs(flatten_keybinds(keybinds)) do
        hl.bind(key, action, get_flags(key))
    end
end

local function extend_keybind(base, suffix)
    return valid_keybind(base) and base .. " + " .. suffix or nil
end

-- Launcher
local launcher_default = normalise_keybind("SUPER + SUPER_L")
create_bind(
    "SUPER + SUPER_L",
    hl.dsp.global("caelestia:launcher"),
    function(key)
        return normalise_keybind(key) == launcher_default and release or nil
    end
)

-- Misc
create_bind("CTRL + ALT + Delete", hl.dsp.global("caelestia:session"))
create_bind("SUPER + N", hl.dsp.global("caelestia:sidebar"))
create_bind("CTRL + ALT + C", hl.dsp.global("caelestia:clearNotifs"), locked)
create_bind("SUPER + K", hl.dsp.global("caelestia:showall"))
create_bind("SUPER + L", hl.dsp.global("caelestia:lock"))

-- Restore lock
create_bind("SUPER + ALT + L", function()
    hl.dispatch(hl.dsp.exec_cmd("caelestia shell -d"))
    hl.dispatch(hl.dsp.global("caelestia:lock"))
end)

-- Kill/restart
create_bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("caelestia shell -k"), release)
create_bind("CTRL + SUPER + ALT + R", hl.dsp.exec_cmd("caelestia shell -r -d"), release)

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    create_bind(extend_keybind("SUPER", key), fn.wsaction("focus", "", i))
    create_bind(extend_keybind("SUPER + ALT", key), fn.wsaction("move", "", i))
    create_bind(extend_keybind("CTRL + SUPER", key), fn.wsaction("focus", "group", i))
    create_bind(extend_keybind("CTRL + SUPER + ALT", key), fn.wsaction("move", "group", i))
end

-- Go to workspace -1/+1
create_bind({ "SUPER + mouse_down", "CTRL + SUPER + Right", "SUPER + Page_Down" }, hl.dsp.focus({ workspace = "+1" }), repeating_unless_mouse)
create_bind({ "SUPER + mouse_up", "CTRL + SUPER + Left", "SUPER + Page_Up" }, hl.dsp.focus({ workspace = "-1" }), repeating_unless_mouse)

-- Go to workspace group -1/+1
create_bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "+10" }), repeating_unless_mouse)
create_bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "-10" }), repeating_unless_mouse)

-- Move window to workspace -1/+1
create_bind({ "SUPER + ALT + mouse_down", "SUPER + ALT + Page_Down", "CTRL + SUPER + SHIFT + Right" }, hl.dsp.window.move({ workspace = "+1" }), repeating_unless_mouse)
create_bind({ "SUPER + ALT + mouse_up", "SUPER + ALT + Page_Up", "CTRL + SUPER + SHIFT + Left" }, hl.dsp.window.move({ workspace = "-1" }), repeating_unless_mouse)

-- Move window to/from special workspace
create_bind({ "SUPER + ALT + S", "CTRL + SUPER + SHIFT + Up" }, hl.dsp.window.move({ workspace = "special:special" }))
create_bind("CTRL + SUPER + SHIFT + Down", hl.dsp.window.move({ workspace = "e+0" }))

-- Window groups
create_bind("ALT + TAB", hl.dsp.window.cycle_next(), repeating)
create_bind("SHIFT + ALT + TAB", hl.dsp.window.cycle_next({ next = false }), repeating)
create_bind("CTRL + ALT + TAB", hl.dsp.group.next(), repeating)
create_bind("CTRL + SHIFT + ALT + TAB", hl.dsp.group.prev(), repeating)
create_bind("SUPER + Comma", hl.dsp.group.toggle())
create_bind("SUPER + U", hl.dsp.window.move({ out_of_group = true }))
create_bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())

-- Window actions
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    create_bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
    create_bind("SUPER + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

create_bind({ "SUPER + Minus", "SUPER + ALT + Left" }, fn.resize_active_window(-10, 0), repeating)
create_bind({ "SUPER + Equal", "SUPER + ALT + Right" }, fn.resize_active_window(10, 0), repeating)
create_bind({ "SUPER + SHIFT + Minus", "SUPER + ALT + Up" }, fn.resize_active_window(0, -10), repeating)
create_bind({ "SUPER + SHIFT + Equal", "SUPER + ALT + Down" }, fn.resize_active_window(0, 10), repeating)

create_bind({ "SUPER + Z", "SUPER + mouse:272" }, hl.dsp.window.drag(), mouse)
create_bind({ "SUPER + X", "SUPER + mouse:273" }, hl.dsp.window.resize(), mouse)
create_bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
create_bind("CTRL + SUPER + ALT + Backslash", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
    hl.dispatch(hl.dsp.window.center())
end)
create_bind("SUPER + ALT + Backslash", function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end)
create_bind("SUPER + P", hl.dsp.window.pin())
create_bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
create_bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
create_bind("SUPER + ALT + Space", hl.dsp.window.float())
create_bind("SUPER + BackSpace", hl.dsp.window.close())

-- Special workspace toggles
create_bind("SUPER + S", fn.toggle_special("specialws"))
create_bind("CTRL + SHIFT + Escape", fn.toggle_special("sysmon"))
create_bind("SUPER + M", fn.toggle_special("music"))
create_bind("SUPER + D", fn.toggle_special("communication"))
create_bind("SUPER + R", fn.toggle_special("todo"))

-- Apps
create_bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
create_bind("SUPER + W", hl.dsp.exec_cmd(browser))
create_bind("SUPER + C", hl.dsp.exec_cmd(editor))
create_bind("SUPER + E", hl.dsp.exec_cmd(fileExplorer))
create_bind("CTRL + ALT + V", hl.dsp.exec_cmd(audioSettings))

-- Utilities
create_bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), locked)
create_bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
create_bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))
create_bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record"))
create_bind("SUPER + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
create_bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))
create_bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Brightness
create_bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), locked)
create_bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), locked)

-- Media
create_bind({ "CTRL + SUPER + Space", "XF86AudioPlay", "XF86AudioPause" }, hl.dsp.global("caelestia:mediaToggle"), locked)
create_bind({ "CTRL + SUPER + Equal", "XF86AudioNext" }, hl.dsp.global("caelestia:mediaNext"), locked)
create_bind({ "CTRL + SUPER + Minus", "XF86AudioPrev" }, hl.dsp.global("caelestia:mediaPrev"), locked)
create_bind({ "CTRL + SUPER + Backspace", "XF86AudioStop" }, hl.dsp.global("caelestia:mediaStop"), locked)

-- Volume
create_bind({ "SUPER + SHIFT + M", "XF86AudioMute" }, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
create_bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
create_bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"
    ),
    locked_repeating
)
create_bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
    ),
    locked_repeating
)

-- Sleep
create_bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"), locked)

-- Clipboard and emoji picker
create_bind("SUPER + V", hl.dsp.exec_cmd("caelestia clipboard"))
create_bind("SUPER + ALT + V", hl.dsp.exec_cmd("caelestia clipboard -d"))
create_bind("SUPER + Period", hl.dsp.exec_cmd("caelestia emoji -p"))
create_bind(
    "CTRL + SHIFT + ALT + V",
    hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
    locked
)

-- Testing
create_bind(
    "SUPER + ALT + F12",
    hl.dsp.exec_cmd(
        "notify-send -u low -i dialog-information-symbolic 'Test notification' " ..
        [["Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!"]] ..
        " -a 'Shell' -A 'Test1=I got it!' -A 'Test2=Another action'"
    )
)
