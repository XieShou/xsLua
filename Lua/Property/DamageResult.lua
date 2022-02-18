---@class DamageResult
local DamageResult = Class("DamageResult")

function DamageResult:__ctor()
    --- 伤害来源
    self.from = 0
    --- 伤害目标
    self.to = 0
    --- 伤害值
    self.damage = 0
    --- 是否暴击
    self.is_critical_hit = false
    --- 是否破防
    self.is_break_defense = false

    --- 造成多少神圣伤害
    self.holy_damage = 0
    --- 格挡了多少伤害
    self.parrying_damage = 0
end
_G.DamageResult = DamageResult
return DamageResult