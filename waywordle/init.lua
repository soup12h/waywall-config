-- ==== cfg

local cfg = {
    x = 200,
    y = 200,
    size = 7,
    start_key = "F11",
}

-- ==== IMPORTS
local waywall = require("waywall")
local M = {}
local h = require("waywordle.helpers")
local words = require("waywordle.words")
local c = require("waywordle.colors")
local valid_words = require("waywordle.valid")
local try_again_text = nil

-- inits
local cur_word = ""
local cur_word_object = nil
Chosen_Word = nil
local word_object = {}
local word_list = {}
local og_remaps = {}
local goredle_overlay_text = nil


function Clear_Goredle()
    Chosen_Word = nil

    waywall.set_remaps(og_remaps)
    for i, _ in pairs(word_object) do
        for j, handle in pairs(word_object[i]) do
            if handle then
                handle:close()
            end
            word_object[i][j] = nil
        end
        word_object[i] = nil
    end
    for k in pairs(word_list) do
        word_list[k] = nil
    end

    word_object = {}
    cur_word = ""
end

function Update_Words(close)
    for i, _ in pairs(word_object) do
        for j, handle in pairs(word_object[i]) do
            if handle then
                handle:close()
            end
            word_object[i][j] = nil
        end
        word_object[i] = nil
    end

    if Goredle_On then
        for i, word in ipairs(word_list) do
            h.print_word(word_object, word, i, cfg)
        end
    end
end

function Update_Goredle(key)
    if cur_word:sub(1, 3) == "You" then
        Clear_Goredle()
    end
    if cur_word_object then
        cur_word_object:close()
        cur_word_object = nil
    end
    if key ~= "Return" then
        if key == "Backspace" then
            cur_word = cur_word:sub(1, math.max(#cur_word - 1, 0))
        else
            if #cur_word < 5 then
                cur_word = cur_word .. key
            end
        end
    elseif key == "Return" and
        #cur_word == 5 and
        h.list_contains(valid_words, cur_word)
    then
        table.insert(word_list, {
            string = cur_word,
            score = h.score_word(cur_word, Chosen_Word)
        })
        if cur_word == Chosen_Word then
            cur_word = "You Win!"
        elseif #word_list >= 6 then
            cur_word = "You Lose!\nWord: \"" .. Chosen_Word .. "\""
        else
            cur_word = ""
        end

        Update_Words(true)
    end
    cur_word_object = waywall.text(cur_word, {
        x = cfg.x,
        y = cfg.y + (cfg.size + 2) * 10 * 8,
        size = cfg.size,
        color = c.text
    })


    return true
end

function Toggle_Goredle(config)
    if goredle_overlay_text then
        goredle_overlay_text:close()
        goredle_overlay_text = nil
    end
    if cur_word_object then
        cur_word_object:close()
        cur_word_object = nil
    end
    -- SWITCH MODE FROM NORMAL TO GOREDLE AND BACK
    if not Goredle_On then
        Update_Words(true)
        -- START GOREDLE
        Goredle_On = true
        goredle_overlay_text = waywall.text("WAYWORDLE", {
            x = cfg.x - (cfg.size * 5 * 2.5),
            y = cfg.y - (cfg.size + 2) / 2,
            size = cfg.size,
            color = c.text
        })

        if not Chosen_Word then
            Chosen_Word = words[math.random(#words)]
        end
        print("Target Word = \"" .. Chosen_Word .. "\"")

        -- SAVE REMAPS AND CACTIONS
        og_remaps = h.original_remaps(config)
    else
        -- STOP GOREDLE
        Goredle_On = false
        Clear_Goredle()
    end
end

M.setup = function(config)
    math.randomseed(os.time())
    math.random(); math.random(); math.random()
    -- Save original remaps
    Goredle_On = false
    h.typing_actions(config, Update_Goredle)

    -- TESTING
    config.actions[cfg.start_key] = function() Toggle_Goredle(config) end
end

return M
