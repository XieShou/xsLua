
local cellCfg = {
    [1] = { ID = 1, Next = {2}},
    [2] = { ID = 2, Next = {3}},
    [3] = { ID = 3, Next = {4}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
    [4] = { ID = 4, Next = {5, 15}},
}

local cell = {}

local map = {}

map.init = function()

end

map.create = function()
    return setmetatable({}, {
        __index = map,
    })
end

