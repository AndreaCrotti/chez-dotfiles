
-- Hyprland config. Docs: https://wiki.hypr.land/Configuring/Start/
-- LSP completion: point workspace.library at /usr/share/hypr/stubs

------------------
---- MONITORS ----
------------------

local f = io.open("/proc/sys/kernel/hostname")
local host = f and f:read("l")
if f then f:close() end

if host == "nuc" then
    hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.2 })
    hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "auto", scale = 1.2 })
else
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "wofi --show drun"

-- ponytail: only the three catppuccin mocha colours this config actually uses.
-- The full palette stays in mocha.conf, which hyprlock (still hyprlang) sources.
local mauve    = "rgb(cba6f7)"
local pink     = "rgb(f5c2e7)"
local surface2 = "rgb(585b70)"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    for _, cmd in ipairs({ "waybar", "swaync", "hyprpaper", "hypridle", "dropbox", "nm-applet", "nwg-dock-hyprland -d" }) do
        hl.exec_cmd(cmd)
    end

    hl.exec_cmd("emacs", { workspace = 1})
    hl.exec_cmd(terminal, { workspace = 1})
    hl.exec_cmd("google-chrome-beta", { workspace = 2})
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Force all apps to use Wayland
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")

-- Use XCompose file
hl.env("XCOMPOSEFILE", "~/.XCompose")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 2,

        col = {
            active_border   = { colors = { mauve, pink }, angle = 45 },
            inactive_border = surface2,
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        active_opacity   = 0.95,
        inactive_opacity = 0.85,

        shadow = {
            enabled      = true,
            range        = 2,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            xray              = true,
            vibrancy          = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper  = -1,
        focus_on_activate        = true,
        disable_splash_rendering = true,
        disable_hyprland_logo    = true,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",      hl.dsp.window.float())
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- Switch to, and move the active window to, workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move the current workspace to another monitor
for i = 1, 5 do
    hl.bind("CTRL + ALT + " .. mainMod .. " + SHIFT + " .. i, hl.dsp.workspace.move({ monitor = i }))
end

-- Resize windows
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -80, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 80,  y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -80, relative = true }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 80,  relative = true }))

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
local mediaFlags = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), mediaFlags)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), mediaFlags)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), mediaFlags)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), mediaFlags)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), mediaFlags)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), mediaFlags)

-- Requires playerctl
local playerFlags = { locked = true }
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"), playerFlags)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), playerFlags)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), playerFlags)
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"), playerFlags)

-- Make a screenshot
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

for _, ns in ipairs({ "waybar", "wofi", "swaync.*" }) do
    hl.layer_rule({ match = { namespace = ns }, blur = true })
end
