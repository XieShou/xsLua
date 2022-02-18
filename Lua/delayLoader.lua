local configLoader = {}

local function GetConfigFileFullPath(k)
    return k
end

setmetatable(configLoader, {
    __index = function(t, k)
        rawset(t, k, require(GetConfigFileFullPath(k)))
    end,
    __newindex = function(t, k, v)
        error("cant set")
    end
})
return configLoader