local t0 = os.clock()

--local AA = 2

local function test2()
    local function test2_5()
        local result = 0
        for i = 1, 1000000000 do
            result = result + AA
        end
        return result
    end
    local function test2_1()
        local function test2_2()
            local function test2_3()
                local function test2_4()

                    return test2_5()
                end
                return test2_4()
            end
            return test2_3()
        end
        return test2_2()
    end
    return test2_5()
end

test2()
local t1 = os.clock()

print(string.format("total time:%.5fms\n", ((t1 - t0) * 1000)))