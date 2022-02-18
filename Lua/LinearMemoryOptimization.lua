---@param hash table 希望使用哈希作为索引
---@param array table 数组
---@param repeatTb table 相同值得数组
function LinearMemoryOptimization(hash, array)
    array.__hash_index = hash
    setmetatable(array, {
        __index = function(tb, key)
            if tb.__hash_index[key] then
                return tb[tb.__hash_index[key]]
            end
            return nil
        end,
    })
    return array
end
testMem("start")

local origin = {
    EventID=7,
    SortIndex=5,
    EventType="CfgEventType.ChargeQuest",
    EventTimeType="CfgEventTimeType.Normal",
    EventName="儲值回饋",
    Icon="GrandTotal",
    TimeDescription="開服30天內",
    EventDescription="購買現金類禮包也是儲值喔！",
    EventNotice=0,
    QuestGroup={7,0},
    EventIndex=7,
    ExchangeIndex=0,
    OpenTime={2018,8,22,0,0},
    CloseTime={2018,9,29,23,59},
    StartTime={2018,8,22,0,0},
    EndTime={2018,9,29,23,59},
    NeedOpenTime=0,
    NeedEndTime=0,
    Param=0,
    TriggerParam=0,
    ActiveFlag=1,
    module={2},
    ConditionType="CfgTutorialConditionType.TutorialProcess",
    ConditionParameter=13,
    OfficialAccountJoin={},
    CleanDropFlag={},
    CleanRecommendShop={},
    CleanExchangeShop=0,
    ChannelType=0,
    Skin=0,
    MutexEvent=0
}
testMem("origin")

---@class ConfigEventInfo
local hash_data = {
    EventID = 1,
    SortIndex = 2,
    EventType = 3,
    EventTimeType = 4,
    EventName = 5,
    Icon = 6,
    TimeDescription = 7,
    EventDescription = 8,
    EventNotice = 9,
    QuestGroup = 10,
    EventIndex=11,
    ExchangeIndex=12,
    OpenTime=13,
    CloseTime=14,
    StartTime=15,
    EndTime=16,
    NeedOpenTime=17,
    NeedEndTime=18,
    Param=19,
    TriggerParam=20,
    ActiveFlag=21,
    module=22,
    ConditionType=23,
    ConditionParameter=24,
    OfficialAccountJoin=25,
    CleanDropFlag=26,
    CleanRecommendShop=27,
    CleanExchangeShop=28,
    ChannelType=29,
    Skin=30,
    MutexEvent=31
}
testMem("struct")
local SAME = {
    empty_tb = {},
    v1 = {2018,8,22,0,0},
    v2 = {2018,9,29,23,59},
}
testMem("same")
local array_data = {
    7,
    5,
    1,
    1,
    "儲值回饋",
    "GrandTotal",
    "開服30天內",
    "購買現金類禮包也是儲值喔！",
    0,
    {7,0},
    7,
    0,
    SAME.v1,
    SAME.v2,
    SAME.v1,
    SAME.v2,
    0,0,0,0,1,{2},1,13,
    SAME.empty_tb,
    SAME.empty_tb,
    SAME.empty_tb,
    0,0,0,0
}
testMem("array")
---@type ConfigEventInfo
local data = LinearMemoryOptimization(hash_data, array_data)

testMem()
print(data.NeedOpenTime)