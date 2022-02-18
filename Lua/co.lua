--local cot = coroutine.create(function(num)
--    local number = num
--    print(number)
--    number = coroutine.yield("test yield")
--    print(number)
--end)
--
--local result, param = coroutine.resume(cot, 1)
--if param then
--    print(param)
--end
--
--coroutine.resume(cot, 2)

local co_pool = {}
local function co_create(f)
    local co = table.remove(co_pool)
    if co == nil then
        co = coroutine.create(function(...)
            f(...)
            while true do
                co_pool[#co_pool + 1] = co
                f = coroutine.yield("SUSPEND")
                f(coroutine.yield())
            end
        end)
    else
        coroutine.resume(co, f)
    end
    return co
end

for i = 1, 10 do
    local function prt(number)
        print(i .. " " .. number)
    end

    coroutine.resume(co_create(prt), "do " .. i)
    print("---------------")
end