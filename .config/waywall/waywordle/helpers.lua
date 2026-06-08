local waywall = require("waywall")
local c       = require("waywordle.colors")

local M       = {}

local letters = {
    "a", "b", "c", "d", "e", "f", "g", "h",
    "i", "j", "k", "l", "m", "n", "o", "p",
    "q", "r", "s", "t", "u", "v", "w", "x",
    "y", "z",
    "Return", "Backspace",
}

function M.original_remaps(config)
    local output = {}
    for key, val in pairs(config.input.remaps or {}) do
        output[key] = val
    end
    return output
end

function M.original_cactions(config)
    local output = {}
    for key, val in pairs(config.actions or {}) do
        output[key] = val
    end
    return output
end

function M.normalize_key(key)
    key = key:gsub("^%*%-", "")
    key = key:lower()
    return key
end

function M.list_contains(words, word)
    for _, w in ipairs(words) do
        if w == word then return true end
    end
    return false
end

function M.typing_actions(config, fn)
    local saved = {}
    for key, func in pairs(config.actions) do
        local normalized_key = M.normalize_key(key)
        if M.list_contains(letters, normalized_key) then
            config.actions[key] = function()
                return Goredle_On and fn(normalized_key) or func()
            end
            saved[normalized_key] = true
        else
            config.actions[key] = function()
                return not Goredle_On and func() or false
            end
        end
    end

    for _, letter in ipairs(letters) do
        if not saved[letter] then
            config.actions["*-" .. letter] = function()
                return Goredle_On and fn(letter) or false
            end
        end
    end
end

function M.score_word(word, target)
    -- 0 = not in word, 1 = wrong place, 2 = right place
    local score = { 0, 0, 0, 0, 0 }

    -- mark greens (2)
    local remaining = {} -- stores the rest of the letters
    for i = 1, 5 do
        local w = word:sub(i, i)
        local t = target:sub(i, i)

        if w == t then
            score[i] = 2
        else
            remaining[t] = (remaining[t] or 0) + 1
        end
    end

    -- mark yellows (1)
    for i = 1, 5 do
        if score[i] == 0 then
            local w = word:sub(i, i)
            if remaining[w] and remaining[w] > 0 then
                score[i] = 1
                remaining[w] = remaining[w] - 1
            end
        end
    end

    return score
end

function M.color_letter(score)
    if score == 0 then
        return c.incorrect
    elseif score == 1 then
        return c.partial
    elseif score == 2 then
        return c.correct
    elseif score == -1 then
        return c.white
    end
end

function M.print_word(word_object, word_c, index, position)
    word_object[index] = word_object[index] or { nil, nil, nil, nil, nil }

    for i = 1, 5 do
        if word_object[index][i] then
            word_object[index][i]:close()
            word_object[index][i] = nil
        end
        local char = word_c.string:sub(i, i)
        word_object[index][i] = waywall.text(char, {
            x = position.x + position.size * 8 * (i - 1),
            y = position.y + (position.size + 2) * 10 * index,
            size = position.size,
            color = M.color_letter(word_c.score[i]),
        })
    end
end

return M
