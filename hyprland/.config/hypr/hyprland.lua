-- Hyprland 0.55+ Lua Configuration
-- Funktionell identisch zu deiner alten Config

--------------------------------------------------------------------------------
-- SOURCING & IMPORTS
--------------------------------------------------------------------------------
-- Externe Konfigurationen laden (Ersetzt die alten 'source =' Befehle)
dofile(os.getenv("HOME") .. "/.devicespecific/hyprlandlocal.conf")

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
    hl.dsp.exec_cmd("waybar")
    hl.dsp.exec_cmd("mako")
    hl.dsp.exec_cmd("hyprpaper")
    hl.dsp.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Optionale Autostarts (auskommentiert)
    -- hl.dsp.exec_cmd("wl-paste --watch cliphist store")
    -- hl.dsp.exec_cmd("fcitx5")
end)

--------------------------------------------------------------------------------
-- UMGEBUNGSVARIABLEN
--------------------------------------------------------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland")

--------------------------------------------------------------------------------
-- EINGABEEINSTELLUNGEN
--------------------------------------------------------------------------------
hl.input({
    kb_layout = "de",
    kb_variant = "",
    kb_model = "",
    kb_options = "grp:alt_shift_toggle",
    kb_rules = "",
    numlock_by_default = true,
    follow_mouse = 1,
    sensitivity = 0,

    touchpad = {
        natural_scroll = true,
        disable_while_typing = true
    }
})

--------------------------------------------------------------------------------
-- ALLGEMEINE EINSTELLUNGEN
--------------------------------------------------------------------------------
hl.general({
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col_active_border = "rgb(ff0080) rgb(4A051C) 45deg",
    col_inactive_border = "rgb(023C40)",
    layout = "dwindle"
    -- cursor_inactive_timeout = 10 -- (Auskommentiert)
})

--------------------------------------------------------------------------------
-- DEKORATIONEN & ANIMATIONEN
--------------------------------------------------------------------------------
hl.decoration({
    rounding = 5,
    blur = {
        enabled = false
    }
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

--------------------------------------------------------------------------------
-- LAYOUTS
--------------------------------------------------------------------------------
hl.dwindle({
    pseudotile = true,
    preserve_split = true
})

hl.gestures({
    -- workspace_swipe = true -- (Auskommentiert)
})

--------------------------------------------------------------------------------
-- FENSTER- & LAYERREGELN
--------------------------------------------------------------------------------
hl.layerrule("ignore_alpha 0, match:namespace waybar")

--------------------------------------------------------------------------------
-- TASTENKÜRZEL (KEYBINDS)
--------------------------------------------------------------------------------
local mainMod = "SUPER"

-- Standard-Binds
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C", "killactive")
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + M", "exit")
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("~/.config/scripts/magic.sh"))

-- Fenster verschieben
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Fokus wechseln
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Arbeitsbereiche wechseln & Fenster verschieben (1-10 per kompakter Lua-Schleife)
for i = 1, 10 do
    local key = i % 10 -- Wandelt 10 in die Taste 0 um
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mausrad-Navigation auf der Leiste
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Fenstergröße ändern
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ size = "-20 0" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ size = "20 0" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ size = "0 -20" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ size = "0 20" }))

-- Zusätzlicher Toggle für Floating
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

--------------------------------------------------------------------------------
-- SUBMAPS (Apps / Resize-Beispiel)
--------------------------------------------------------------------------------

hl.bind("ALT + SHIFT + Y", hl.dsp.submap("apps"))

hl.submap("apps", function()
    for i = 1, 10 do
        local key = i % 10
        hl.bind("CTRL_SHIFT + " .. key, hl.dsp.focus({ workspace = i }))
    end
    hl.bind(mainMod .. " + ALT + F7", hl.dsp.submap("reset"))
end)
