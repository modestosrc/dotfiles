pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local common = require("awful.widget.common")

local show_hide_state = "show"

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

-- Meu tema
beautiful.init("/home/mateus/.config/awesome/default/theme.lua")

-- Supostamente inicia polybar só se nao estiver iniciado
awful.spawn.once("polybar")

-- autorun meus apps
autorun = true
autorunApps = {
    --"xset m 0 0",
    "xinput --set-prop 9 'libinput Accel Profile Enabled' 0, 1",
    "setxkbmap -layout br",
    "xmodmap ~/.Xmodmap",
}

if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn(autorunApps[app])
    end
end

terminal = "kitty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

awful.layout.layouts = {
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator amateusnd switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    awful.screen.focused().padding = { top = "0", bottom = "0" }

    -- Each screen has its own tag table.
    awful.tag({ "󰈹", "󰆍", "", "󰉋", "󰓇", "󰓓", "󰙯" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    -- s.mytaglist = awful.widget.taglist {
    --     screen  = s,
    --     filter  = awful.widget.taglist.filter.all,
    --     style   = {
    --         shape = gears.shape.powerline
    --     },
    --     layout   = {
    --         spacing = -12,
    --         spacing_widget = {
    --             color  = '#dddddd',
    --             shape  = gears.shape.powerline,
    --             widget = wibox.widget.separator,
    --         },
    --         layout  = wibox.layout.fixed.horizontal
    --     },
    --     widget_template = {
    --         {
    --             {
    --                 {
    --                     {
    --                         {
    --                             id     = 'index_role',
    --                             widget = wibox.widget.textbox,
    --                         },
    --                         margins = 4,
    --                         widget  = wibox.container.margin,
    --                     },
    --                     bg     = '#dddddd',
    --                     shape  = gears.shape.circle,
    --                     widget = wibox.container.background,
    --                 },
    --                 {
    --                     {
    --                         id     = 'icon_role',
    --                         widget = wibox.widget.imagebox,
    --                     },
    --                     margins = 2,
    --                     widget  = wibox.container.margin,
    --                 },
    --                 {
    --                     id     = 'text_role',
    --                     widget = wibox.widget.textbox,
    --                 },
    --                 layout = wibox.layout.fixed.horizontal,
    --             },
    --             left  = 18,
    --             right = 18,
    --             widget = wibox.container.margin
    --         },
    --         id     = 'background_role',
    --         widget = wibox.container.background,
    --         -- Add support for hover colors and an index label
    --         create_callback = function(self, c3, index, objects) --luacheck: no unused args
    --             self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
    --             self:connect_signal('mouse::enter', function()
    --                 if self.bg ~= '#ff0000' then
    --                     self.backup     = self.bg
    --                     self.has_backup = true
    --                 end
    --                 self.bg = '#ff0000'
    --             end)
    --             self:connect_signal('mouse::leave', function()
    --                 if self.has_backup then self.bg = self.backup end
    --             end)
    --         end,
    --         update_callback = function(self, c3, index, objects) --luacheck: no unused args
    --             self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
    --         end,
    --     },
    --     buttons = taglist_buttons
    -- }

    --     -- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist {
    --    screen          = s,
    --    filter          = awful.widget.tasklist.filter.currenttags,
    --    --filter          = awful.widget.tasklist.filter.allscreen,
    --    buttons         = tasklist_buttons,
    --    style           = {
    --        shape_border_width = 0,
    --        shape_border_color = '#777777',
    --        shape              = gears.shape.rounded_bar,
    --    },
    --    layout          = {
    --        spacing        = 10,
    --        --spacing_widget = {
    --        --    {
    --        --        forced_width = 5,
    --        --        shape        = gears.shape.circle,
    --        --        widget       = wibox.widget.separator
    --        --    },
    --        --    valign = 'center',
    --        --    halign = 'center',
    --        --    widget = wibox.container.place,
    --        --},
    --        layout         = wibox.layout.flex.horizontal
    --    },
    --    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    --    -- not a widget instance.
    --    widget_template = {
    --        {
    --            {
    --                {
    --                    {
    --                        id     = 'icon_role',
    --                        widget = wibox.widget.imagebox,
    --                    },
    --                    margins = 2,
    --                    widget  = wibox.container.margin,
    --                },
    --                {
    --                    id     = 'text_role',
    --                    widget = wibox.widget.textbox,
    --                },
    --                layout = wibox.layout.fixed.horizontal,
    --            },
    --            left   = 10,
    --            right  = 10,
    --            widget = wibox.container.margin
    --        },
    --        id     = 'background_role',
    --        widget = wibox.container.background,
    --    },
    --}

    -- -- Create the wibox
    --s.mywibox = awful.wibar({ position = "bottom", screen = s })

    ---- Add widgets to the wibox
    --s.mywibox:setup {
    --    layout = wibox.layout.align.horizontal,
    --    { -- Left widgets
    --        layout = wibox.layout.fixed.horizontal,
    --        --mylauncher,
    --        --s.mytaglist,
    --        --s.mypromptbox,
    --    },
    --    s.mytasklist, -- Middle widget
    --    {             -- Right widgets
    --        layout = wibox.layout.fixed.horizontal,
    --        --spotify_widget({
    --        --    font = 'FiraCode',
    --        --    play_icon = '/usr/share/icons/Papirus-Light/24x24/categories/spotify.svg',
    --        --    pause_icon = '/usr/share/icons/Papirus-Dark/24x24/panel/spotify-indicator.svg',
    --        --    dim_when_paused = true,
    --        --    dim_opacity = 0.5,
    --        --    max_length = -1,
    --        --    show_tooltip = false,
    --        --    sp_bin = gears.filesystem.get_configuration_dir() .. 'scripts/sp'
    --        --}),
    --        --volume_widget({
    --        --    widget_type = 'arc',
    --        --    device = 'pulse'
    --        --}),
    --        --cpu_widget({
    --        --    width = 70,
    --        --    step_width = 2,
    --        --    step_spacing = 0,
    --        --    color = '#99d1db'
    --        --}),
    --        ----docker_widget(),
    --        --fs_widget(),
    --        --mykeyboardlayout,
    --        --wibox.widget.systray(),
    --        --mytextclock,
    --        --s.mylayoutbox,
    --    },
    --}
end)


-- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--     awful.button({ }, 3, function () mymainmenu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --          {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "r", function() awful.util.spawn("rofi -modes \"drun,window\" -show drun") end,
        { description = "open rofi", group = "launcher" }),
    awful.key({ "Mod1" }, "Tab", function() awful.util.spawn("rofi -modes \"window\" -show window") end,
        { description = "open rofi", group = "launcher" }),
    awful.key({ modkey }, "BackSpace",
        function() awful.spawn("rofi -show power-menu -modi power-menu:~/bin/rofi-power-menu") end,
        { description = "Show Power Menu", group = "custom" }),
    awful.key({}, "Print", function() awful.spawn("flameshot gui") end,
        { description = "Take screenshot", group = "screenshot" }),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" })
)


clientkeys = gears.table.join(
    awful.key({ modkey, "Control" }, "h", function ()
        if show_hide_state == "show" then
            -- Se o último comando foi "pshow", execute "phide"
            awful.spawn.with_shell("zsh -i -c 'phide'")
            show_hide_state = "hide"
        else
            -- Se o último comando foi "phide", execute "pshow"
            awful.spawn.with_shell("zsh -i -c 'pshow'")
            show_hide_state = "show"
        end
    end),

    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
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

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    {
        rule_any = { class = { "Polybar" } },
        properties = { focusable = false }
    },


    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer" },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    {
        rule = { class = "Firefox" },
        properties = { screen = 1, tag = "1" }
    },
    {
        rule = { class = "Kitty" },
        properties = { screen = 1, tag = "2" }
    },
    {
        rule = { class = "Xfe" },
        properties = { screen = 1, tag = "4" }
    },
    {
        rule = { class = "Spotify" },
        properties = { screen = 1, tag = "5" }
    },
    {
        rule = { class = "Steam" },
        properties = { screen = 1, tag = "6" }
    },
    {
        rule = { class = "Spotify" },
        properties = { screen = 1, tag = "7" }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )


    awful.titlebar(c):setup {
        {  -- Left
            --awful.titlebar.widget.iconwidget(c),
            --buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {      -- Middle
            {  -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            --buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {  -- Right
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            -- awful.titlebar.widget.ontopbutton    (c),
            --awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }

    awful.titlebar(c):setup {
        {  -- Left
            --awful.titlebar.widget.iconwidget(c),
            --buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {      -- Middle
            {  -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            --buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {  -- Right
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            -- awful.titlebar.widget.ontopbutton    (c),
            --awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
