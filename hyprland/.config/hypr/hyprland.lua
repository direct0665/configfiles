--------------------------------------------------------------------------------
-- SOURCING & IMPORTS
--------------------------------------------------------------------------------
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.devicespecific/?.lua"
pcall(require, "hyprlandlocal")

--------------------------------------------------------------------------------
-- MONITORE
--------------------------------------------------------------------------------
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1
})

--------------------------------------------------------------------------------
-- AUTOSTART PROGRAMME
--------------------------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

--------------------------------------------------------------------------------
-- GLOBALE CONFIG-VARIABLEN
--------------------------------------------------------------------------------
hl.config({
    env = {
        { "XCURSOR_SIZE",         "24" },
        { "QT_QPA_PLATFORMTHEME", "qt5ct" },
        { "QT_QPA_PLATFORM",      "wayland" },
        { "SDL_VIDEODRIVER",      "wayland" },
        { "CLUTTER_BACKEND",      "wayland" },
        { "GDK_BACKEND",          "wayland" }
    },

    input = {
        kb_layout = "de",
        kb_options = "grp:alt_shift_toggle",
        numlock_by_default = true,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true
        }
    },

    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        ["col.active_border"] = "rgb(ff0080) rgb(4A051C) 45deg",
        ["col.inactive_border"] = "rgb(023C40)",
        layout = "dwindle"
    },

    decoration = {
        rounding = 5,
        blur = {
            enabled = false
        }
    },

    dwindle = {
        preserve_split = true
    }
})

--------------------------------------------------------------------------------
-- FENSTER- & LAYERREGELN
--------------------------------------------------------------------------------
hl.layer_rule({
    match = { namespace = "waybar" },
    ignore_alpha = 0
})

--------------------------------------------------------------------------------
-- ANIMATIONEN
--------------------------------------------------------------------------------
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

--------------------------------------------------------------------------------
-- TASTENKÜRZEL (KEYBINDS)
--------------------------------------------------------------------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", "exec, kitty")
hl.bind(mainMod .. " + C", "killactive")
hl.bind(mainMod .. " + Q", "exec, kitty")
hl.bind(mainMod .. " + M", "exit")
hl.bind(mainMod .. " + E", "exec, dolphin")
hl.bind(mainMod .. " + V", "togglefloating")
hl.bind(mainMod .. " + R", "exec, wofi --show drun")
hl.bind(mainMod .. " + P", "pseudo")
hl.bind(mainMod .. " + J", "togglesplit")
hl.bind(mainMod .. " + F", "exec, firefox")
hl.bind(mainMod .. " + Y", "exec, hyprlock")
hl.bind(mainMod .. " + X", "exec, ~/.config/scripts/magic.sh")

hl.bind(mainMod .. " + SHIFT + left", "movewindow, l")
hl.bind(mainMod .. " + SHIFT + right", "movewindow, r")
hl.bind(mainMod .. " + SHIFT + up", "movewindow, u")
hl.bind(mainMod .. " + SHIFT + down", "movewindow, d")

hl.bind(mainMod .. " + left", "movefocus, l")
hl.bind(mainMod .. " + right", "movefocus, r")
hl.bind(mainMod .. " + up", "movefocus, u")
hl.bind(mainMod .. " + down", "movefocus, d")
hl.bind(mainMod .. " + h", "movefocus, l")
hl.bind(mainMod .. " + l", "movefocus, r")
hl.bind(mainMod .. " + k", "movefocus, u")
hl.bind(mainMod .. " + j", "movefocus, d")

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, "workspace, " .. i)
    hl.bind(mainMod .. " + SHIFT + " .. key, "movetoworkspace, " .. i)
end

hl.bind(mainMod .. " + mouse_down", "workspace, e+1")
hl.bind(mainMod .. " + mouse_up", "workspace, e-1")

hl.bind(mainMod .. " + CTRL + left", "resizeactive, -20 0")
hl.bind(mainMod .. " + CTRL + right", "resizeactive, 20 0")
hl.bind(mainMod .. " + CTRL + up", "resizeactive, 0 -20")
hl.bind(mainMod .. " + CTRL + down", "resizeactive, 0 20")

hl.bind(mainMod .. " + SHIFT + F", "togglefloating")

--------------------------------------------------------------------------------
-- SUBMAPS
--------------------------------------------------------------------------------
hl.bind("ALT + SHIFT + Y", "submap, apps")

hl.submap("apps", function()
    for i = 1, 10 do
        local key = i % 10
        hl.bind("CTRL_SHIFT + " .. key, "workspace, " .. i)
    end
    hl.bind(mainMod .. " + ALT + F7", "submap, reset")
end)
