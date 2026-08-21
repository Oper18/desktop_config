-- rc.lua (Fedora-friendly, based on your Arch config)
-- Keeps the same hotkeys, terminal (kitty), theme (lain themes), and top statusbar info.

pcall(require, "luarocks.loader")

-- Workaround for GLib >= 2.86 / LGI change:
-- Gio.UnixInputStream moved to GioUnix.InputStream (breaks Awesome 4.3 awful.spawn.lua)
do
    local ok_lgi, lgi = pcall(require, "lgi")
    if ok_lgi and lgi and lgi.Gio and (lgi.Gio.UnixInputStream == nil) and lgi.GioUnix and lgi.GioUnix.InputStream then
        lgi.Gio.UnixInputStream = lgi.GioUnix.InputStream
    end
    if ok_lgi and lgi and lgi.Gio and (lgi.Gio.UnixOutputStream == nil) and lgi.GioUnix and lgi.GioUnix.OutputStream then
        lgi.Gio.UnixOutputStream = lgi.GioUnix.OutputStream
    end
end

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local my_wallpaper = os.getenv("HOME") .. "/.config/wallpaper/Apotheosis.jpg"
require("awful.hotkeys_popup.keys")

local has_lain, lain = pcall(require, "lain")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title  = "AwesomeWM startup errors!",
        text   = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title  = "AwesomeWM error!",
            text   = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
local themes = {
    "blackburn",
    "copland",
    "dremora",
    "holo",
    "multicolor",
    "powerarrow",
    "powerarrow-dark",
    "rainbow",
    "steamburn",
    "vertex",
}

local chosen_theme = themes[3] -- dremora (same as your original)
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

terminal   = "/usr/bin/ghostty -e " .. os.getenv("HOME") .. "/.local/bin/herdr"
-- terminal   = "kitty -e tmux new -A -s main"
-- terminal   = "kitty -e zellij attach main -c"
editor     = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

-- Keyboard layouts: English + Russian
-- awful.spawn.with_shell(
--     "setxkbmap -layout us,ru -option grp:ctrl_alt_toggle"
-- )
-- awful.spawn.with_shell([[
--     setxkbmap -layout us,ru -option grp:ctrl_alt_toggle
--     for id in $(xinput list --id-only --name-only | grep -i keyboard); do
--         setxkbmap -device "$id" -layout us,ru -option grp:ctrl_alt_toggle
--     done
-- ]])


awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
}
-- }}}

-- {{{ Autostart (Fedora-safe)
local function spawn_once(cmd)
    awful.spawn.with_shell(string.format("pgrep -u $USER -x '%s' >/dev/null || (%s)", cmd:match("^(%S+)") or cmd, cmd))
end

-- Display: avoid hardcoding output names like eDP-1 / eDP-1-1 / etc.
awful.spawn.with_shell("command -v xrandr >/dev/null 2>&1 && xrandr --auto")

-- Compositor / notifications (only if installed)
spawn_once("picom -b")
awful.spawn.with_shell("picom --backend glx")
spawn_once("dunst")
-- spawn_once(os.getenv("HOME") .. "/.config/scripts/display.sh &")
spawn_once("touchegg &")
-- }}}

-- kwallet
awful.spawn.with_shell("dbus-update-activation-environment --systemd DISPLAY XAUTHORITY")
awful.spawn.with_shell("kwalletd5 &")

-- {{{ Menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
    }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
-- }}}

mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()

-- {{{ Widgets (statusbar: same info as your original)
local function safe_lain_widget(make)
    if not has_lain then
        return wibox.widget.textbox(" lain: missing ")
    end
    local ok, widget = pcall(make)
    if ok and widget then return widget end
    return wibox.widget.textbox(" widget err ")
end

local cpu_widget = safe_lain_widget(function()
    return lain.widget.cpu({
        settings = function()
            widget:set_markup(" CPU: " .. cpu_now.usage .. "% ")
        end
    }).widget
end)

local mem_widget = safe_lain_widget(function()
    return lain.widget.mem({
        settings = function()
            widget:set_markup(" MEM: " .. mem_now.used .. "MB ")
        end
    }).widget
end)

-- local volume_widget = safe_lain_widget(function()
--     return lain.widget.alsa({
--         settings = function()
--             widget:set_markup(" Vol: " .. volume_now.level .. "% ")
--         end
--     }).widget
-- end)
local volume_widget = wibox.widget.textbox()

gears.timer {
    timeout = 2,
    autostart = true,
    call_now = true,
    callback = function()
        awful.spawn.easy_async_with_shell(
            "wpctl get-volume @DEFAULT_AUDIO_SINK@",
            function(out)
                local vol = out:match("(%d+%.%d+)")
                if vol then
                    volume_widget:set_text("Vol: " .. math.floor(tonumber(vol)*100) .. "%")
                else
                    volume_widget:set_text("Vol: N/A")
                end
            end
        )
    end
}

local battery_widget = safe_lain_widget(function()
    return lain.widget.bat({
        timeout = 5,
        settings = function()
            local bat_perc = (bat_now.perc or "N/A") .. "%"
            widget:set_markup("Battery: " .. bat_perc .. " | Status: " .. (bat_now.status or "N/A"))
        end
    }).widget
end)

-- Network widget (nmcli, as in your original). Will just show N/A if nmcli not present.
local net_widget = wibox.widget.textbox()
local function update_net_widget()
    awful.spawn.easy_async_with_shell(
        "command -v nmcli >/dev/null 2>&1 && nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || echo 'N/A'",
        function(stdout1)
            local ssid = (stdout1 or ""):gsub("\n", "")
            awful.spawn.easy_async_with_shell(
                "command -v nmcli >/dev/null 2>&1 && nmcli -f IN-USE,SIGNAL dev wifi list | grep '*' | awk '{print $2}' || echo 'N/A'",
                function(stdout2)
                    local sig = (stdout2 or ""):gsub("\n", "")
                    net_widget:set_text("Net: " .. ssid .. " | Signal: " .. sig)
                end
            )
        end
    )
end

gears.timer {
    timeout   = 5,
    call_now  = true,
    autostart = true,
    callback  = update_net_widget,
}

local separator = wibox.widget {
    widget        = wibox.widget.separator,
    orientation   = "vertical",
    forced_width  = 10,
    thickness     = 3,
    color         = "#0B7000",
}
-- }}}

-- {{{ Taglist / Tasklist
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)
-- }}}

-- {{{ Wallpaper
local function set_wallpaper(s)
    gears.wallpaper.maximized(my_wallpaper, s, true)
end
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Wibar (top bar)
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag({ "1","2","3","4","5","6","7","8","9" }, s, awful.layout.layouts[1])

    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function() awful.layout.inc(1) end),
        awful.button({ }, 3, function() awful.layout.inc(-1) end),
        awful.button({ }, 4, function() awful.layout.inc(1) end),
        awful.button({ }, 5, function() awful.layout.inc(-1) end)
    ))

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle
        { -- Right
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            separator,
            net_widget,
            separator,
            cpu_widget,
            separator,
            mem_widget,
            separator,
            volume_widget,
            separator,
            battery_widget,
            separator,
            mytextclock,
            separator,
            wibox.widget.systray(),
            separator,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function() mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings (same as your original)
globalkeys = gears.table.join(
    awful.key({ modkey }, "s", hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

    awful.key({ modkey }, "Left",  awful.tag.viewprev, {description="view previous", group="tag"}),
    awful.key({ modkey }, "Right", awful.tag.viewnext, {description="view next", group="tag"}),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, {description="go back", group="tag"}),

    awful.key({ modkey }, "j", function() awful.client.focus.byidx(1) end,
        {description="focus next by index", group="client"}),
    awful.key({ modkey }, "k", function() awful.client.focus.byidx(-1) end,
        {description="focus previous by index", group="client"}),

    awful.key({ modkey }, "m", function() mymainmenu:show() end,
        {description="show main menu", group="awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        {description="swap with next client by index", group="client"}),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        {description="swap with previous client by index", group="client"}),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        {description="focus the next screen", group="screen"}),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        {description="focus the previous screen", group="screen"}),

    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        {description="jump to urgent client", group="client"}),

    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end, {description="go back", group="client"}),

    -- Standard program
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
        {description="open a terminal", group="launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
        {description="reload awesome", group="awesome"}),

    awful.key({ modkey, "Shift" }, "e", awesome.quit,
        {description="quit awesome", group="awesome"}),

    awful.key({ modkey }, "l", function() awful.tag.incmwfact(0.05) end,
        {description="increase master width factor", group="layout"}),
    awful.key({ modkey }, "h", function() awful.tag.incmwfact(-0.05) end,
        {description="decrease master width factor", group="layout"}),

    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        {description="increase the number of master clients", group="layout"}),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        {description="decrease the number of master clients", group="layout"}),

    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        {description="increase the number of columns", group="layout"}),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        {description="decrease the number of columns", group="layout"}),

    awful.key({ modkey }, "space", function() awful.layout.inc(1) end,
        {description="select next", group="layout"}),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        {description="select previous", group="layout"}),

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, {description="restore minimized", group="client"}),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        {description="run prompt", group="launcher"}),

    awful.key({ modkey }, "x", function()
        awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        }
    end, {description="lua execute prompt", group="awesome"}),

    -- Launcher
    awful.key({ modkey }, "d", function()
        awful.spawn.with_shell("command -v rofi >/dev/null 2>&1 && rofi -show drun || true")
    end, {description="rofi drun", group="Launcher"}),

    -- Lock
    awful.key({ modkey }, "p", function()
        awful.spawn.with_shell("command -v i3lock >/dev/null 2>&1 && i3lock -c 1f0303 -k || true")
    end, {description="Lock screen", group="layout"}),

    -- Window controls
    awful.key({ modkey, "Shift" }, "q", function()
        if client.focus then client.focus:kill() end
    end, {description="Close window", group="layout"}),

    awful.key({ modkey }, "w", function()
        if client.focus then
            client.focus.maximized = true
            client.focus:raise()
        end
    end, {description="Maximize window", group="layout"}),

    awful.key({ modkey }, "e", function()
        if client.focus then
            client.focus.maximized = false
            client.focus:raise()
        end
    end, {description="Unmaximize window", group="layout"}),

    -- Media keys
    -- awful.key({ }, "XF86AudioMute", function()
    --     awful.spawn.with_shell("command -v amixer >/dev/null 2>&1 && amixer set Master mute || true")
    -- end, {description="Mute volume", group="media"}),

    -- awful.key({ }, "XF86AudioLowerVolume", function()
    --     awful.spawn.with_shell("command -v amixer >/dev/null 2>&1 && amixer set Master 3%- unmute || true")
    -- end, {description="Set volume lower", group="media"}),

    -- awful.key({ }, "XF86AudioRaiseVolume", function()
    --     awful.spawn.with_shell("command -v amixer >/dev/null 2>&1 && amixer set Master 3%+ unmute || true")
    -- end, {description="Set volume higher", group="media"}),
    awful.key({ }, "XF86AudioMute", function()
        awful.spawn.with_shell("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    end),
    
    awful.key({ }, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
    end),
    
    awful.key({ }, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
    end),

    -- Brightness keys (kept same; guarded so it won't break if 'light' isn't installed)
    awful.key({ }, "XF86MonBrightnessDown", function()
        awful.spawn.with_shell("command -v light >/dev/null 2>&1 && sudo light -U 5 || true")
    end, {description="Set brightness lower", group="higher"}),

    awful.key({ }, "XF86MonBrightnessUp", function()
        awful.spawn.with_shell("command -v light >/dev/null 2>&1 && sudo light -A 5 || true")
    end, {description="Set brightness higher", group="higher"}),

    -- Screenshot (kept same; guarded)
    awful.key({ }, "Print", function()
        awful.spawn.with_shell("command -v scrot >/dev/null 2>&1 && /usr/bin/scrot ~/Screenshots/`date +'%Y-%m-%d_%H-%M-%S'`.jpg || true")
    end, {description="Fullscreen screenshot", group="higher"}),

    awful.key({ "Ctrl" }, "Print", function()
        awful.spawn.with_shell("command -v scrot >/dev/null 2>&1 && /usr/bin/scrot -u ~/Screenshots/`date +'%Y-%m-%d_%H-%M-%S'`.jpg || true")
    end, {description="Window screenshot", group="higher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {description="toggle fullscreen", group="client"}),

    awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
        {description="close", group="client"}),

    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        {description="toggle floating", group="client"}),

    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        {description="move to master", group="client"}),

    awful.key({ modkey }, "o", function(c) c:move_to_screen() end,
        {description="move to screen", group="client"}),

    awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end,
        {description="toggle keep on top", group="client"}),

    awful.key({ modkey }, "n", function(c) c.minimized = true end,
        {description="minimize", group="client"}),

    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, {description="(un)maximize", group="client"}),

    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {description="(un)maximize vertically", group="client"}),

    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {description="(un)maximize horizontally", group="client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then tag:view_only() end
        end, {description="view tag #"..i, group="tag"}),

        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then awful.tag.viewtoggle(tag) end
        end, {description="toggle tag #"..i, group="tag"}),

        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:move_to_tag(tag) end
            end
        end, {description="move focused client to tag #"..i, group="tag"}),

        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then client.focus:toggle_tag(tag) end
            end
        end, {description="toggle focused client on tag #"..i, group="tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { class = "kitty" },
      properties = {
          maximized = true,
          raise = true
      }
    },
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus        = awful.client.focus.filter,
          raise        = true,
          keys         = clientkeys,
          buttons      = clientbuttons,
          screen       = awful.screen.preferred,
          placement    = awful.placement.no_overlap + awful.placement.no_offscreen,
      }
    },

    { rule_any = {
        instance = { "DTA", "copyq", "pinentry" },
        class    = {
            "Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin",
            "Sxiv", "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
        },
        name = { "Event Tester" },
        role = { "AlarmWindow", "ConfigManager", "pop-up" },
      },
      properties = { floating = true }
    },

    { rule_any = { type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true }
    },

    { rule = { class = "Tabletop Simulator" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { align = "center", widget = awful.titlebar.widget.titlewidget(c) },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
