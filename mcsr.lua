-- == imports ==
local waywall = require("waywall")
local helpers = require("waywall.helpers")
local create_floating = require("floating.floating")
local plug = require("plug.init")

local Scene = require("waywork.scene")
local Modes = require("waywork.modes")
local Keys = require("waywork.keys")
local Processes = require("waywork.processes")

-- == paths ==
local resources_folder = os.getenv("HOME") .. "/" .. ".config/waywall/resources/"

local bg_path = resources_folder .. "images/background.png"
local eye_overlay_path = resources_folder .. "images/measuring_overlay.png"
local border_paths = {
    tall = resources_folder .. "images/overlay_tall.png",
    thin = resources_folder .. "images/overlay_thin.png",
    wide = resources_folder .. "images/overlay_wide.png",
}

local java_path = "/usr/lib/jvm/java-25-openjdk/bin/java"
local paceman_path = resources_folder .. "jars/paceman-tracker-0.7.1.jar"
local ninbot_path = resources_folder .. "jars/Ninjabrain-Bot-1.5.1.jar"

-- == read helper function ==
local read_file = function(name)
    local file = io.open(name, "r")
    if file then
        local data = file:read("*a")
        file:close()
        return data
    end
end

-- == config variables ==
local ninbot_anchor, ninbot_opacity = "topright", 0.9
local normal_sens, tall_sens = 7.66600442, 0.44967824
local xkb_layout = "norge"
local keybinds = {
    enabled = {
        ["TAB"] = "F3",
        ["F3"] = "TAB",

        ["E"] = "BACKSPACE",
        ["BACKSPACE"] = "E",

        ["V"] = "HOME",
        ["HOME"] = "V",

        ["MIDDLEMOUSE"] = "RIGHTSHIFT",
        ["RIGHTSHIFT"] = "MIDDLEMOUSE",

        ["MB4"] = "LEFTCTRL",
        ["LEFTCTRL"] = "MB4",

        ["MB5"] = "F12",
        ["F12"] = "MB5",
    },

    disabled = {
        ["TAB"] = "F3",
        ["F3"] = "TAB",

        ["MB5"] = "F12",
        ["F12"] = "MB5",
    }
}

local keys = {
    -- mode toggles
    thin = "*-H",
    tall = "*-Y",
    wide = "*-Caps_Lock",

    -- apps
    toggle_ninbot = "*-Alt_L",
    launch_paceman = "Shift-P",

    -- waywall actions
    fullscreen = "F5",
    toggle_rebinds = "End",
}

-- == main config ==
local config = {
    input = {
        layout = xkb_layout,
        repeat_rate = 150,
        repeat_delay = 150,
        remaps = keybinds.enabled,
        sensitivity = normal_sens,
        confine_pointer = false,
    },
    theme = {
        background = "#000000",
        background_png = bg_path,
        ninb_anchor = ninbot_anchor,
        ninb_opacity = ninbot_opacity,
    },
    experimental = { debug = false, jit = false, tearing = false, scene_add_text = true, },
    shaders = {
        ["borders"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/colors.glsl") .. "\n" .. read_file(resources_folder .. "shaders/borders.frag"),
        },
        ["pie_chart"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/colors.glsl") .. "\n" .. read_file(resources_folder .. "shaders/pie_chart.frag"),
        },
        ["pie_border"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/colors.glsl") .. "\n" .. read_file(resources_folder .. "shaders/pie_border.frag"),
        },
        ["text"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/colors.glsl") .. "\n" .. read_file(resources_folder .. "shaders/text.frag"),
        },
        ["text_bg"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/colors.glsl") .. "\n" .. read_file(resources_folder .. "shaders/text_bg.frag"),
        },
    },
}

-- == floating controller ==
local floating = create_floating({
    show_floating = waywall.show_floating,
    sleep = waywall.sleep,
})

-- == scene registry ==
local scene = Scene.SceneManager.new(waywall)

-- == mirrors ==
-- = normal =
-- blockentities
scene:register("glowdar", {
    kind = "mirror",
    options = {
        src = { x = 1827, y = 858, w = 34, h = 36 },
        dst = { x = 1667, y = 678, w = 169, h = 179 },
        shader = "text",
    },
    groups = { "normal" },
})
scene:register("glowdar_shadow", {
    kind = "mirror",
    options = {
        src = { x = 1827, y = 858, w = 34, h = 36 },
        dst = { x = 1672, y = 683, w = 169, h = 179 },
        shader = "text_bg",
    },
    groups = { "normal" },
})

-- = thin =
-- c and e counter
scene:register("c_e_counter", {
    kind = "mirror",
    options = {
        src = { x = 1, y = 28, w = 64, h = 18 },
        dst = { x = 1300, y = 450, w = 320, h = 90 },
        shader = "text",
    },
    groups = { "thin" },
})
scene:register("c_e_counter_shadow", {
    kind = "mirror",
    options = {
        src = { x = 1, y = 28, w = 64, h = 18 },
        dst = { x = 1305, y = 455, w = 320, h = 90 },
        shader = "text_bg",
    },
    groups = { "thin" },
})

-- o counter
scene:register("o_counter", {
    kind = "mirror",
    options = {
        src = { x = 45, y = 154, w = 64, h = 10 },
        dst = { x = 1300, y = 545, w = 320, h = 50 },
        shader = "text",
    },
    groups = { "thin" },
})
scene:register("o_counter_shadow", {
    kind = "mirror",
    options = {
        src = { x = 45, y = 154, w = 64, h = 10 },
        dst = { x = 1305, y = 550, w = 320, h = 50 },
        shader = "text_bg",
    },
    groups = { "thin" },
})

-- pitch and yaw
scene:register("pitch_yaw", {
    kind = "mirror",
    options = {
        src = { x = 177, y = 118, w = 64, h = 10 },
        dst = { x = 1300, y = 600, w = 320, h = 50 },
        shader = "text",
    },
    groups = { "thin" },
})
scene:register("pitch_yaw_shadow", {
    kind = "mirror",
    options = {
        src = { x = 177, y = 118, w = 64, h = 10 },
        dst = { x = 1305, y = 605, w = 320, h = 50 },
        shader = "text_bg",
    },
    groups = { "thin" },
})

-- pie
scene:register("pie", {
    kind = "mirror",
    options = {
        src = { x = 0, y = 674, w = 340, h = 178},
        dst = { x = 1225, y = 650, w = 315, h = 317.25 },
        depth = 2,
        shader = "pie_chart",
    },
    groups = { "thin" },
})
scene:register("pie_border", {
    kind = "mirror",
    options = {
        src = { x = 0, y = 674, w = 340, h = 178},
        dst = { x = 1220, y = 645, w = 325, h = 327.25 },
        depth = 1,
        shader = "pie_border",
    },
    groups = { "thin" },
})

-- pie percentages
scene:register("percentages", {
    kind = "mirror",
    options = {
        src = { x = 247, y = 859, w = 33, h = 25 },
        dst = { x = 1550, y = 750, w = 132, h = 100 },
        shader = "text",
    },
    groups = { "thin" },
})
scene:register("percentages_shadow", {
    kind = "mirror",
    options = {
        src = { x = 247, y = 859, w = 33, h = 25 },
        dst = { x = 1553, y = 753, w = 132, h = 100 },
        shader = "text_bg",
    },
    groups = { "thin" },
})

-- = tall =
-- eye measure mirror
scene:register("eye_measure", {
    kind = "mirror",
    options = {
        src = { x = 177, y = 7902, w = 30, h = 580 },
        dst = { x = 30, y = 340, w = 700, h = 400 },
    },
    groups = { "tall" },
})

-- eye measure overlay
scene:register("eye_overlay", {
    kind = "image",
    path = eye_overlay_path,
    options = { dst  = { x = 30, y = 340, w = 700, h = 400 } },
    groups = { "tall" },
})

-- = res borders =
for _, name in ipairs({ "wide", "thin", "tall" }) do
    scene:register(name .. "_border", {
        kind = "image",
        path = border_paths[name],
        options = { dst = { x = 0, y = 0, w = 1920, h = 1080 } },
        groups = { name },
        depth = -1,
    })
end

-- == modes ==
local mode_manager = Modes.ModeManager.new(waywall)

mode_manager:define("normal", {
    width = 1920,
    height = 1080,
})

mode_manager:define("thin", {
    width = 340,
    height = 1080,
    on_enter = function()
        scene:enable_group("thin", true)
        scene:enable_group("normal", false)
    end,
    on_exit = function()
        scene:enable_group("thin", false)
        scene:enable_group("normal", true)
    end,
})

mode_manager:define("tall", {
    width = 384,
    height = 16384,
    toggle_guard = function()
        return not waywall.get_key("F3")
    end,
    on_enter = function()
        scene:enable_group("tall", true)
        scene:enable_group("normal", false)
        waywall.set_sensitivity(tall_sens)
    end,
    on_exit = function()
        scene:enable_group("tall", false)
        scene:enable_group("normal", true)
        waywall.set_sensitivity(normal_sens)
    end,
})

mode_manager:define("wide", {
    width = 1920,
    height = 300,
    on_enter = function()
        scene:enable_group("wide", true)
        scene:enable_group("normal", false)
    end,
    on_exit = function()
        scene:enable_group("wide", false)
        scene:enable_group("normal", true)
    end,
})

-- == jar processes ==
local ensure_ninjabrain = Processes.ensure_java_jar(waywall, java_path, ninbot_path, { "-Dawt.useSystemAAFontSettings=on" })(ninbot_path)
local ensure_paceman = Processes.ensure_java_jar(waywall, java_path, paceman_path, { "--nogui" })(paceman_path)

-- == action helper booleans ==
-- = ninbot =
local is_ninb_ensured = false

-- = remaps =
local remaps_active = true
local remaps_text = nil

-- == config actions ==
local actions = Keys.actions({
    -- = mode toggles ==
    [keys.thin] = function() return mode_manager:toggle("thin") end,
    [keys.tall] = function() return mode_manager:toggle("tall") end,
    [keys.wide] = function() return mode_manager:toggle("wide") end,

    -- = fullscreen toggle =
    [keys.fullscreen] = waywall.toggle_fullscreen,

    -- = nbb =
    [keys.toggle_ninbot] = function()
    -- ensure ninbot
        if not is_ninb_ensured then
            ensure_ninjabrain()
            floating.show()
            floating.hide_after_timeout(5000)
            is_ninb_ensured = true
        else
            floating.override_toggle()
        end
    end,
    -- temporarily show ninbot on F3+C
    ["*-C"] = function()
        if waywall.get_key("F3") then
            waywall.press_key("C")
            floating.show()
            floating.hide_after_timeout(30000)
        else
            return false
        end
    end,
    -- hide ninbot on calculator reset
    ["*-APOSTROPHE"] = function()
        if floating.is_overridden() then
            floating.override_off()
        else
            floating.hide()
        end
    end,

    -- = paceman =
    [keys.launch_paceman] = function() ensure_paceman() end,

    -- = rebinds toggle =
    [keys.toggle_rebinds] = function()
        -- warning text
        if remaps_text then
            remaps_text:close(); remaps_text = nil
        end
        if remaps_active then
            -- turn off all rebinds
            remaps_active = false
            waywall.set_remaps(keybinds.disabled)
            waywall.set_keymap({ layout = "us" })
            remaps_text = waywall.text("rebinds off", { x = 100, y = 100, color = "#FFFFFF", size = 2 })
        else
            -- turn on all rebinds
            remaps_active = true
            waywall.set_remaps(keybinds.enabled)
            waywall.set_keymap({ layout = xkb_layout })
        end
    end,
})

config.actions = actions

-- == plugins ==
plug.setup({
    dir = "plugins",
    config = config,
    path = "~/.config/waywall/plugins/",
})

return config
