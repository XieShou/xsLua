local Filter = require("Lua/Filter/Filter")
--- 存一张配置表
local FilterConfig = {}
---@alias tbs "allOf" | "anyOf" | "noneOf"
FilterConfig._register = {}

---@alias add_or_remove fun(data:table, value:any):table | nil
---@param addFunc add_or_remove
---@param removeFunc add_or_remove
function FilterConfig.Register(condition, addFunc, removeFunc, exportFunc)
    FilterConfig._register[condition] = {
        addFunc = addFunc,
        removeFunc = removeFunc,
        exportFunc = exportFunc,
    }
end

---@param tb tbs
function FilterConfig:Add(tb, condition, value)
    if condition == nil or not FilterConfig._register[condition] then
        return
    end
    if self[tb][condition] == nil then
        self[tb][condition] = {}
    end
    self[tb][condition] = FilterConfig._register[condition].addFunc(self[tb][condition], value)
end

---@param tb tbs
function FilterConfig:Remove(tb, condition, value)
    if condition == nil or not FilterConfig._register[condition] then
        return
    end
    if self[tb][condition] == nil then
        self[tb][condition] = {}
    end
    self[tb][condition] = FilterConfig._register[condition].removeFunc(self[tb][condition], value)
end

--- 导出配置
---@return Filter
function FilterConfig:Export()
    local filter = Filter.New()
    for condition, config in pairs(self.allOf) do
        filter:AllOf(FilterConfig._register[condition].exportFunc(config))
    end
    for condition, config in pairs(self.noneOf) do
        filter:NoneOf(FilterConfig._register[condition].exportFunc(config))
    end
    for condition, config in pairs(self.anyOf) do
        filter:AnyOf(FilterConfig._register[condition].exportFunc(config))
    end
    return filter
end

function FilterConfig.New()
    ---@class filter_config
    local obj = {}
    obj.allOf = {}
    obj.anyOf = {}
    obj.noneOf = {}
    setmetatable(obj, {
        __index = FilterConfig
    })
    return obj
end

return FilterConfig