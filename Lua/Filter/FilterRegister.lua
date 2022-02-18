FilterConfig = require("Lua/Filter/FilterConfig")

local function line_add(config, value)
    for i = 1, #config do
        if config[i] == value then
            break
        end
    end
    table.insert(config, value)
    return config
end

local function line_remove(config, value)
    for i = 1, #config do
        if config[i] == value then
            table.remove(config, i)
            break
        end
    end
    return config
end

FilterConfig.Register("Quality", line_add, line_remove, function(config)
    -- 设置成upvalue
    local config = config
    return function(k, v, s,t )
        -- data为过滤器传入的运行时数据，例如道具信息
        for i = 1, #config do
            if v.Quality == config[i] then
                return true
            end
        end
        return false
    end
end)

FilterConfig.Register("Type", line_add, line_remove, function(config)
    local config = config
    return function(k, v)
        for i = 1, #config do
            if v.Type == config[i] then
                return true
            end
        end
        return false
    end
end)