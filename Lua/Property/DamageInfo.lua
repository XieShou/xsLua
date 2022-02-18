---@class DamageInfo
local DamageInfo = Class("DamageInfo")

function DamageInfo:__ctor()
    --- 伤害来源ID
    self.from = 0
    --- 伤害目标ID
    self.to = 0
    --- 原始命中率
    self.originAccuracy = 10000
    --- 生效命中率
    self.thresholdAccuracy = 8000
    --- 伤害原因
    ---@type DamageReason
    self.reason = nil
    ---@type DamageResult[]
    self.results = {}
end

function DamageInfo:__dtor()

end

---@param result DamageResult
function DamageInfo:AddResult(result)
    table.insert(self.results, result)
end

return DamageInfo