


require("Cfg/CfgEventType")
require("Cfg/CfgEventTimeType")
require("Cfg/CfgTutorialConditionType")
require("Cfg/CfgNinjaLevelType")

testMem()
require("Cfg/CfgEventInfo")
testMem()

---通过这个函数获得table的结构深度和结构体映射
local function get_config_main_struct(rawConfig)
    local depth = 0

    local count = 0
    local struct = {}
    local raw = rawConfig
    local over = false
    while (not over) and raw do
        depth = depth + 1
        for i, v in pairs(raw) do
            if type(i) == "number" then
                raw = v
            else
                over = true
            end
            break
        end
    end

    struct = {}
    for i, v in pairs(raw) do
        count = count + 1
        struct[i] = count
    end

    return depth,count, struct
end


local depth, count, struct = get_config_main_struct(CfgEventInfo)

testMem()
--print(depth, count, dump_tostring(struct))

local function convertHashTb2ArrayTb(rawConfig, depth, struct, count)
    local raw = rawConfig
    local gen = {}

    local gen_func
    gen_func = function(raw, gen, depth)
        if depth > 1 then
            for i, raw_v in pairs(raw) do
                -- 在这里构建一个线性数组给
                local lineTb = {}
                for i = 1, count do
                    lineTb[i] = 1
                end
                for struct_k, struct_v in pairs(struct) do
                    lineTb[struct_v] = raw_v[struct_k]
                end
                --setmetatable(lineTb, {
                --    __index = function(obj, key)
--
                --    end,
                --    __newindex = function(obj, key, v)
--
                --    end
                --})
                gen[i] = lineTb
            end
        else
            for i, v in pairs(raw) do
                gen[i] = {}
                gen_func(v, gen[i], depth - 1)
            end
        end
    end
    gen_func(raw, gen, depth)
    return gen
end

testMem()
local gen = convertHashTb2ArrayTb(CfgEventInfo, depth, struct, count)
print("====================")
--print(dump_tostring(gen))
CfgEventInfo = nil
testMem()