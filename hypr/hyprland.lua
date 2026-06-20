-------------------
--- ENABLE LOGS ---
-------------------

hl.config({
  debug = {disable_logs = false,},
})


local function getHostname()
    local f = io.popen ("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname =string.gsub(hostname, "\n$", "")
    return hostname
end

host = getHostname() 

----------------
--- MONITORS ---
----------------

monitor_mode = 0

local function applymonitors()
  monitor_mode = monitor_mode % 2
  if monitor_mode == 0 then -- side by side with any monitor
    hl.monitor({
      output    = "eDP-1",
      mode      = "2880x1800@120",
      position  = "0x0", 
      scale     = "1.6667",
    })
    hl.monitor({
      output    = "HDMI-A-1",
      mode      = "preferred", 
      position  = "0x0",
      scale     = "1.25",
    })
    hl.monitor({
      output    = "DP-2",
      mode      = "preferred", 
      position  = "auto",
      scale     = "1",
    })
  end

  if monitor_mode == 1 then -- 2nd monitor above laptop, HG D11
    hl.monitor({
      output    = "eDP-1",
      mode      = "2880x1800@120",
      position  = "160x1152", 
      scale     = "1.6667",
    })

    hl.monitor({
      output    = "HDMI-A-1",
      mode      = "2560x1440@99.90", 
      position  = "0x0",
      scale     = "1.25",
    })
    hl.monitor({
      output    = "DP-2",
      mode      = "2560x1440@60", 
      position  = "0x0",
      scale     = "1.25",
    })
  end

  hl.exec_cmd("pkill hyprpaper && hyprpaper & disown")
end
applymonitors()

-- cycle monitor settings
hl.bind("f23", function ()
  monitor_mode = monitor_mode + 1
  applymonitors()
end)
-------------------
--- MY PROGRAMS ---
-------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "~/.config/hypr/scripts/wofi-toggle.sh"
local browser     = "firefox"
local pdf         = "zathura"

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hyprpm reload")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for discord screensharing
  hl.exec_cmd("bluetoothctl trust 28:11:A5:DE:7F:A2")
  hl.exec_cmd("bluetoothctl power on")
  hl.exec_cmd("bluetoothctl connect 28:11:A5:DE:7F:A2")
  -- hl.exec_cmd("hyprctl plugin load ~/development/hypr-bongocat/hypr-bongocat.so")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
  hl.exec_cmd("sleep 0.1 && nextcloud --background")
end)

----------------
--- ENV VARS ---
----------------

hl.env("XCURSOR_SIZE", "24")
hl.env("LD_PRELOAD", "")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRSHOT_DIR", "Pictures/Screenshots")
hl.env("GSK_RENDERER", "gl") -- prevents nautilus crashes (i hope)

-------------------
--- PERMISSIONS ---
-------------------

hl.config({
  ecosystem = {
    no_donation_nag = true,
    enforce_permissions = true,
  },
})

hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/lib/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow"})
hl.permission({ binary = "/home/thomas/development/Hyprfoci/hyprfoci.so", type = "plugin", mode = "allow" })
hl.permission({ binary = "/home/thomas/development/hypr-bongocat/hypr-bongocat.so", type = "plugin", mode = "allow" })
hl.permission({ binary = "/var/cache/hyprpm/thomas/Hyprfoci/hyprfoci.so", type = "plugin", mode = "allow" })
hl.permission({ binary = "/var/cache/hyprpm/thomas/hypr-bongocat/hypr-bongocat.so", type = "plugin", mode = "allow" })
hl.permission({ binary = "/var/cache/hyprpm/thomas/hyprland-plugins/csgo-vulkan-fix.so", type = "plugin", mode = "allow" })

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(4a9d9bee)", "rgba(3b6d80ee)"}, angle = 45 },
            inactive_border = "rgba(5b5e4faa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.9,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0x1a1a1aee,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    xwayland = { 
      force_zero_scaling = true
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
        force_split = 2,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

------------
--- MISC ---
------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        animate_manual_resizes = true,
        vrr = 1,
    },
})

-------------
--- INPUT ---
-------------
if host == "archlinux" then 
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "compose:rctrl",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = -0.75, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = flat,

        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.5,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
})
elseif host == "PC-Arch" then
  hl.config({
      input = {
          kb_layout  = "us",
          kb_variant = "",
          kb_model   = "",
          kb_options = "compose:rctrl",
          kb_rules   = "",

          follow_mouse = 1,

          sensitivity = -0.85, -- -1.0 - 1.0, 0 means no modification.
          accel_profile = flat,

          touchpad = {
              natural_scroll = true,
              scroll_factor = 0.5,
          },
      },
  })
end

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name          = "syna8018:00-06cb:ce67-touchpad",
    sensitivity   = 0,
    accel_profile = adaptive,
})

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode=fullscreen, action=toggle}))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(pdf))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ direction = "left"}))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ direction = "down"}))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ direction = "up"}))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ direction = "right"}))

-- Change window size, was 20 in old config
hl.bind(mainMod .. " + SHIFT +  L", hl.dsp.window.resize({ x=20, y=0, relative=true}))
hl.bind(mainMod .. " + SHIFT +  H", hl.dsp.window.resize({ x=-20, y=0, relative=true}))
hl.bind(mainMod .. " + SHIFT +  K", hl.dsp.window.resize({ x=0, y=-20, relative=true}))
hl.bind(mainMod .. " + SHIFT +  J", hl.dsp.window.resize({ x=0, y=20, relative=true})) 

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 20000+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 20000-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-------------------
--- SCREENSHOTS ---
-------------------

-- screenshot monitor to clipboard
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"))
-- screenshot a monitor to ~/Pictures/Screenshots, set as HYPRSHOT_DIR
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m output -m active"))
-- screenshot active window to clipboard
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window -m active --clipboard-only"))
-- screenshot active window to ~/Pictures/Screenshots, set as HYPRSHOT_DIR
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window -m active --clipboard-only"))

---------------------------
--- WAYBAR TRANSPARENCY ---
---------------------------

hl.window_rule({
  name = "waybar-transparency",
  opacity = 0.8,
  match = { class = "waybar", title = "waybar"},
})

-----------------------
--- BONGO CATS OMFG ---
-----------------------

hl.config({
  plugin = {
    hypr_bongocat = {
      size = { 125, 0 },
      pos = { 0, -39 },
      origin = { 1, 0 },
      imgs = "~/.config/hypr/hypr-bongocat/bongo",
      exclude = "",
    },
  }
})

----------------------
--- RESOLUTION FIX ---
----------------------

hl.config({
  plugin = {
    csgo_vulkan_fix = {
      fix_mouse = true,
    }
  }
})

hl.plugin.csgo_vulkan_fix.vkfix_app({ app = "Minecraft 26.1.2", w = 2880, h = 1800 })
