--local str = {
--    [0.1] = "拉弓进入蓄力状态，根据蓄力时间连续射出<color=571E0E>1</color>至<color=571E0E>2</color>枚贯穿的火焰之箭。蓄力期间可主动结束蓄力状态，立即射出火焰之箭，冷却时间<color=571E0E>36</color>秒。",
--    [0.2] = "向前扔出高速旋转的镰刀，停留一段时间返回后召唤出凶恶的亡魂向前突刺，冷却时间<color=571E0E>35</color>秒。",
--    [3] = "在正前方召唤<color=571E0E>3条</color>曲线前进的小水龙，短暂蓄力后召唤更大的水龙，冷却时间<color=571E0E>36</color>秒。",
--    [4] = "召唤剑柄向正前方发射冲击波，剑柄会跟随人物缓慢移动，冷却时间<color=571E0E>36</color>秒。"
--}
--for i, v in pairs(str) do
--    local des = string.gsub(v, "<color=#?[0-Z]*>", "<color=F57200>")
--    print(des)
--end

--require("tools")
--require("line_tb_simple_test")
--require("test_line_tb")
--require("LinearMemoryOptimization")
--local name = "驭火拨浪鼓sd改sdssss"
--local DOT_LEN = string.len("sd")
--local nameResult = {}
--for word in string.gmatch(name, "%P+s+d") do
--    print(word)
--    table.insert(nameResult, word)
--end

--local pointPos = string.len(nameResult[1])
--local result = string.sub(name, 1,  pointPos - DOT_LEN) .. "\n" .. string.sub(name, pointPos + 1, string.len(name))

--for i, v in ipairs(config) do
--    if string.find(v[1]) then
--        return string.gsub(str, v[1], v[2])
--    end
--end
--
--return str
--
--print(result)

require("Lua/sort")