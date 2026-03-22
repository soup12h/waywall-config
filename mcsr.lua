-- == imports ==
local waywall = require("waywall")
local waywall = require("waywall")
local helpers = require("waywall.helpers")
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

-- == helper functions ==
-- = read file function for shaders =
local read_file = function(name)
    local file = io.open(name, "r")
    if file then
        local data = file:read("*a")
        file:close()
        return data
    end
end

-- == config variables ==
local ninbot_anchor, ninbot_opacity, ninbot_offset_y = "topright", 0.9, 0
local normal_sens, tall_sens = 16, 1.07935043
local xkb_layout = "norge"
local keybinds = {
    enabled = {
        ["TAB"] = "F3",
        ["F3"] = "TAB",

        ["BACKSPACE"] = "E",
        ["E"] = "BACKSPACE",

        ["HOME"] = "V",
        ["V"] = "HOME",

        ["MIDDLEMOUSE"] = "RIGHTSHIFT",
        ["RIGHTSHIFT"] = "MIDDLEMOUSE",

        ["MB4"] = "LEFTCTRL",
        ["LEFTCTRL"] = "MB4",

        ["MB5"] = "F12",
        ["F12"] = "MB5",
    },

    disabled = {
        
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
        repeat_rate = 100,
        repeat_delay = 150,
        remaps = keybinds.enabled,
        sensitivity = normal_sens,
        confine_pointer = true,
    },
    theme = {
        background = "#000000",
        background_png = bg_path,
        ninb_anchor = { 
            position = ninbot_anchor,
            x = 0,
            y = ninbot_offset_y,
        },
        ninb_opacity = ninbot_opacity,
    },
    experimental = { debug = false, jit = false, tearing = false, scene_add_text = true, },
    shaders = {
        ["borders"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/borders.frag"),
        },
        ["pie_chart"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/pie_chart.frag"),
        },
        ["pie_border"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/pie_border.frag"),
        },
        ["spawn"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/spawner.frag"),
        },
        ["spawn_bg"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/spawner_bg.frag"),
        },
        ["chest"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/chest.frag"),
        },
        ["chest_bg"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/chest_bg.frag"),
        },
        ["text"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/text.frag"),
        },
        ["text_bg"] = {
            vertex = read_file(resources_folder .. "shaders/general.vert"),
            fragment = read_file(resources_folder .. "shaders/frag/text_bg.frag"),
        },
    },
}

-- == scene registry ==
local scene = Scene.SceneManager.new(waywall)

-- == mirrors ==
-- = normal =
-- spawner
for i = 0, 3, 1 do
    helpers.res_mirror(
        {
            src = { x = 1827, y = 859 + 8 * i, w = 33, h = 9 },
            dst = { x = 1685, y = 720, w = 33 * 4, h = 9 * 4 },
            depth = 3,
            shader = "spawn",
        },
        0, 0
    )
    helpers.res_mirror({
            src = { x = 1827, y = 859 + 8 * i, w = 33, h = 9 },
            dst = { x = 1685 + 4, y = 720 + 4, w = 33 * 4, h = 9 * 4 },
            depth = 2,
            shader = "spawn_bg",},
        0, 0
    )
end

-- chest
for i = 0, 3, 1 do
    helpers.res_mirror( -- mob_spawner
        {
            src = { x = 1827, y = 859 + 8 * i, w = 33, h = 9 },
            dst = { x = 1685, y = 755, w = 33 * 4, h = 9 * 4 },
            depth = 3,
            shader = "chest",
        },
        0, 0
    )
    helpers.res_mirror( -- mob_spawner
        {
            src = { x = 1827, y = 859 + 8 * i, w = 33, h = 9 },
            dst = { x = 1685 + 4, y = 755 + 4, w = 33 * 4, h = 9 * 4 },
            depth = 2,
            shader = "chest_bg",
        },
        0, 0
    )
end

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
scene:register("pie_thin", {
    kind = "mirror",
    options = {
        src = { x = 0, y = 674, w = 340, h = 178},
        dst = { x = 1225, y = 650, w = 315, h = 317.25 },
        depth = 2,
        shader = "pie_chart",
    },
    groups = { "thin" },
})
scene:register("pie_border_thin", {
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
scene:register("percentages_thin", {
    kind = "mirror",
    options = {
        src = { x = 247, y = 859, w = 33, h = 25 },
        dst = { x = 1550, y = 750, w = 132, h = 100 },
        shader = "text",
    },
    groups = { "thin" },
})
scene:register("percentages_shadow_thin", {
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

-- pie
scene:register("pie_tall", {
    kind = "mirror",
    options = {
        src = { x = 44, y = 15978, w = 340, h = 178},
        dst = { x = 1225, y = 650, w = 315, h = 317.25 },
        depth = 2,
        shader = "pie_chart",
    },
    groups = { "tall" },
})
scene:register("pie_border_tall", {
    kind = "mirror",
    options = {
        src = { x = 44, y = 15978, w = 33, h = 25},
        dst = { x = 1220, y = 645, w = 325, h = 327.25 },
        depth = 1,
        shader = "pie_border",
    },
    groups = { "tall" },
})

-- pie percentages
scene:register("percentages_tall", {
    kind = "mirror",
    options = {
        src = { x = 291, y = 16163, w = 33, h = 25 },
        dst = { x = 1550, y = 750, w = 132, h = 100 },
        shader = "text",
    },
    groups = { "tall" },
})
scene:register("percentages_shadow_tall", {
    kind = "mirror",
    options = {
        src = { x = 291, y = 16163, w = 33, h = 25 },
        dst = { x = 1553, y = 753, w = 132, h = 100 },
        shader = "text_bg",
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

-- = pie dir display =
local pie_dst_2 = { x = 1811, y = 1013, w = 98, h = 53 }
local pie_dst_2_sh = { x = 1803, y = 1005, w = 113, h = 68 }
local pie_dst_1 = { x = 1698, y = 1013, w = 98, h = 53 }
local pie_dst_1_sh = { x = 1691, y = 1005, w = 113, h = 68 }
local yMultConstant = 8
-- tick
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_2,
		depth = 3,
		color_key = { input = "#6543CA", output = "#6543CA" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_2_sh,
		depth = 2,
		color_key = { input = "#6543CA", output = "#000000" },
	}, 0, 0)
end
-- level
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_2,
		depth = 3,
		color_key = { input = "#63cbc2", output = "#63cbc2" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_2_sh,
		depth = 2,
		color_key = { input = "#63cbc2", output = "#000000" },
	}, 0, 0)
end
-- entities
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_2,
		depth = 5,
		color_key = { input = "#e145c2", output = "#e145c2" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_2_sh,
		depth = 4,
		color_key = { input = "#e145c2", output = "#000000" },
	}, 0, 0)
end
-- blockEntities
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_2,
		depth = 5,
		color_key = { input = "#c4c46d", output = "#c4c46d" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_2_sh,
		depth = 4,
		color_key = { input = "#c4c46d", output = "#000000" },
	}, 0, 0)
end

-- gameRenderer
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_1,
		depth = 5,
		color_key = { input = "#c2cbc2", output = "#c2cbc2" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_1_sh,
		depth = 4,
		color_key = { input = "#c2cbc2", output = "#000000" },
	}, 0, 0)
end
-- level
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_1,
		depth = 3,
		color_key = { input = "#63cbc2", output = "#63cbc2" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_1_sh,
		depth = 2,
		color_key = { input = "#63cbc2", output = "#000000" },
	}, 0, 0)
end
-- entities
for i = 0, 6, 1 do
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
		dst = pie_dst_1,
		depth = 5,
		color_key = { input = "#e145c2", output = "#e145c2" },
	}, 0, 0)
	helpers.res_mirror({
		src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
		dst = pie_dst_1_sh,
		depth = 4,
		color_key = { input = "#e145c2", output = "#000000" },
	}, 0, 0)
end

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
    [keys.thin] = helpers.ingame_only(function() return mode_manager:toggle("thin") end),
    [keys.tall] = helpers.ingame_only(function() return mode_manager:toggle("tall") end),
    [keys.wide] = helpers.ingame_only(function() return mode_manager:toggle("wide") end),

    -- = fullscreen toggle =
    [keys.fullscreen] = waywall.toggle_fullscreen,

    -- = nbb =
    [keys.toggle_ninbot] = function()
    -- ensure ninbot/toggle override
        if not is_ninb_ensured then
            ensure_ninjabrain()
            waywall.show_floating(true)
        else
            helpers.toggle_floating()
        end
    end,
    -- show ninbot on F3+C
    ["*-C"] = function()
        if waywall.get_key("F3") then
            waywall.show_floating(true)
            return false
        else
            return false
        end
    end,
    -- hide ninbot on F3+C
    ["APOSTROPHE"] = function()
        waywall.show_floating(false)
        return false
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
require("waywordle.init").setup(config)

return config
