---@class Entity :Unit
local Entity = Class("Entity", Unit)

function Entity:__ctor()
    ---@type Property
    self.property = Property.New()
    self.isDied = false
end

---@return boolean
function Entity:CheckIsDied()
    return self.isDied
end

return Entity