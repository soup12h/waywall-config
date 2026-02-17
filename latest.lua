local waywall = require("waywall")
local helpers = require("waywall.helpers")
local plug = require("plug.init")

local config = {
    input = {
        layout = "us",
        repeat_rate = 150,
        repeat_delay = 150,
        sensitivity = 7.66600442,
    },
}

config.actions = {
    ["F5"] = waywall.toggle_fullscreen,
}

plug.setup({
    dir = "plugins",
    config = config,
    path = "~/.config/waywall/plugins/",
})

return config
