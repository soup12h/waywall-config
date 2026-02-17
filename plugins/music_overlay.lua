local cfg = {
    overlay = false,
    look = {
        X = 70,
        Y = 920,
        color = '#000000',
        size = 3,
        max_len = 30,
    },
    previous = "F8",
    play_pause = "F10",
    next = "F9",
}

return {
    url = "https://github.com/arjuncgore/ww_music_overlay",
    config = function(config)
        require("music_overlay.init").setup(config, cfg)
    end,
    name = "music_overlay",
    update_on_load = false,
}
