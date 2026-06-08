-- for earlier and later vesions of minecraft
local waywall = require("waywall")
local helpers = require("waywall.helpers")
local plug = require("plug.init")

local config = {
    input = {
        layout = "us",
        repeat_rate = 110,
        repeat_delay = 150,
        sensitivity = 16,
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
require("waywordle.init").setup(config)

return config
