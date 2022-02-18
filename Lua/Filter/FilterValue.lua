---@class FilterValue
local FilterValue = {}

function FilterValue:eq(a, b)
    return true
end

function FilterValue:ctor()
    
end

function FilterValue:Serialize()
    
end

function FilterValue:DeSerialize()
    
end

function FilterValue:Extend(type)
    local cls = {}
    cls._type = type
    setmetatable(cls, {
        __index = FilterValue,
    })
    return cls
end

function FilterValue:New()
    local obj = {}
    setmetatable(obj, {
        __eq = self.eq,
        __index = self,
    })
    return obj
end

return FilterValue