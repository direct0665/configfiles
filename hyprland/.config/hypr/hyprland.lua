--------------------------------------------------------------------------------
-- SOURCING & IMPORTS
--------------------------------------------------------------------------------
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.devicespecific/?.lua"
pcall(require, "hyprlandlocal")

--------------------------------------------------------------------------------
-- MONITORE
--------------------------------------------------------------------------------
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
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
        { "GDK_BACKEND",          "wayland" },
    },

    input = {
        kb_layout          = "de",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "grp:alt_shift_toggle",
        kb_rules           = "",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0,
        touchpad           = {
            natural_scroll       = true,
            disable_while_typing = true,
        },
    },

    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        col         = {
            active_border   = { colors = { "rgb(ff0080)", "rgb(4A051C)" }, angle = 45 },
            inactive_border = "rgb(023C40)",
        },
        layout      = "dwindle",
    },

    decoration = {
        rounding = 5,
        blur = {
            enabled = false,
        },
    },

    dwindle = {
        pseudotile     = true,
        preserve_split = true,
    },
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
-- FENSTER- & LAYERREGELN
--------------------------------------------------------------------------------
hl.layer_rule({
    name         = "ignore-waybar-alpha",
    match        = { namespace = "waybar" },
    ignore_alpha = 0,
})

--------------------------------------------------------------------------------
-- TASTENKÜRZEL (KEYBINDS)
--------------------------------------------------------------------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/.config/scripts/magic.sh"))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0 }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0 }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20 }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20 }))

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

--------------------------------------------------------------------------------
-- SUBMAPS
--------------------------------------------------------------------------------
hl.bind("ALT + SHIFT + Y", hl.dsp.submap("apps"))

-- Submap Definitionen werden über globale Binds innerhalb des Scopes registriert
for i = 1, 10 do
    local key = i % 10
    hl.bind("CTRL_SHIFT + " .. key, hl.dsp.focus({ workspace = i }), { submap = "apps" })
end
hl.bind(mainMod .. " + ALT + F7", hl.dsp.submap("reset"), { submap = "apps" })
