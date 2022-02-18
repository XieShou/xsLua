---@class entity
local entity = {}
entity.id = 0

function entity.AddComponent(self, component, ...)

end

function entity.RemoveComponent(self, component, ...)

end

entity.New = function()
    entity.id = entity.id + 1
    return setmetatable({id = entity.id}, {
        __index = entity
    })
end