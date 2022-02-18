---@class EntityManager
local EntityManager = Class("EntityManager")

function EntityManager:__ctor()
    ---@type table<number, Entity>
    self.entities = {}
end

---@param eid number
---@return Entity
function EntityManager:GetEntity(eid)
    return self.entities[eid]
end

--- 改变Entity属性
---@param eid number
function EntityManager:ChangeEntityProperty(eid, ePropertyType, ...)
    local entity = self.entities[eid]

    local success, msg = entity:ChangeProperty(ePropertyType, ...)
    if success then
        --- 如果是服务器，需要同步到客户端
    else
        if msg then
            error("change entity property error " .. msg)
        end
    end
end

return EntityManager
