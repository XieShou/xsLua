
--- 获得随机值
local function Random(a, b)
    return math.random(a, b)
end

--- 随机值数是否满足（万分制）
local function CheckRandom10000(value)
    local randomNum = math.random(0, 10000)
    return value < randomNum
end

local DamageManager = Class("DamageManager")

local Common_Is_Died = DamageResult.New(DamageConst.DamageResultType.IsDied)
local Common_Is_Miss = DamageResult.New(DamageConst.DamageResultType.Miss)
local Common_Zero_Damage = DamageResult.New(DamageConst.DamageResultType.Zero)

function DamageManager:__ctor()
    self.damageInfoList = {}
end

function DamageManager:__dtor()

end

--- 一帧计算伤害
function DamageManager:Tick()
    --- 计算当前帧伤害结果
    ---@type DamageResult[]
    local damageResultList = {}
    for i = 1, self.damageInfoList do
        self:Schedule(self.damageInfoList[i], damageResultList)
    end

    --- 根据结果进行实际掉血运算
    local result = {}
    for i, v in ipairs(damageResultList) do
        if not result[v.to] then
            result[v.to] = 0
        end
        result[v.to] = result[v.to] + v.damage + v.holy_damage
    end

    for eid, damage in pairs(result) do
        EntityManager:ChangeEntityProperty(eid, EPropertyType.HP, entity.property.hp - damage)
    end
end

--- 根据伤害信息计算伤害
---@param damageInfo DamageInfo
---@param damageResultList DamageResult[]
function DamageManager:Schedule(damageInfo, damageResultList)
    if damageInfo.reason.type == DamageConst.DamageReasonType.Attack then
        self:GetDamageResult_Attack(damageInfo, damageResultList)
    elseif damageInfo.reason.type == DamageConst.DamageReasonType.Skill then
        self:GetDamageResult_Skill(damageInfo, damageResultList)
    elseif damageInfo.reason.type == DamageConst.DamageReasonType.Buff then
        self:GetDamageResult_Buff(damageInfo, damageResultList)
    end
end

--- 计算普通攻击结果
---@param damageInfo DamageInfo
---@param damageResultList DamageResult[]
function DamageManager:GetDamageResult_Attack(damageInfo, damageResultList)
    ---@type Entity
    local from = EntityManager:GetEntity(damageInfo.from)
    ---@type Entity
    local to = EntityManager:GetEntity(damageInfo.to)
    if to:CheckIsDied() then
        damageInfo:AddResult(Common_Is_Died)
        --- 目标已经死亡
        return nil
    end

    local from_property = from.property
    local to_property = to.property

    --- 生效命中率 = 原始命中程度 + from_命中率 - to_闪避率
    local accuracy = damageInfo.OriginAccuracy + from_property.accuracy - to_property.dodge
    --- 生效命中率低于80%时进行命中判定
    if accuracy <= damageInfo.thresholdAccuracy then
        if not CheckRandom10000(accuracy) then
            damageInfo:AddResult(Common_Is_Miss)
            return nil
        end
    end

    --- 直接伤害加成属性（破防 -> to_防御，暴击 -> from_攻击）
    --- 基础伤害
    local _from_ap = from_property.attack_point
    local _to_dp = to_property.defense_point

    --- 暴击
    --- 是否暴击了（暴击率 - 暴击率抵抗）
    local _is_critical_hit = CheckRandom10000(from_property.critical_hit_rate - to_property.critical_hit_rate_defence)
    if _is_critical_hit then
        -- 计算过暴击后的暴击伤害
        _from_ap = math.floor((1 + from_property.critical_hit_value / 10000) * _from_ap)
    end

    --- 破防
    local _is_break_defense = CheckRandom10000(from_property.break_defense_rate - to_property.break_defense_rate_defence)
    if _is_break_defense then
        -- 计算过破防后的破防护甲
        _to_dp = math.floor((1 - from_property.critical_hit_value / 10000) * _to_dp)
    end

    if _from_ap - _to_dp <= 0 then
        -- 打不穿护甲0伤害
        damageInfo:AddResult(Common_Zero_Damage)
        return nil
    end
    --- 伤害加深
    local _damage_increase = 1 + (from_property.damage_increase - to_property.damage_decrease) / 10000
    local damage = math.floor((_from_ap - _to_dp) * _damage_increase)


    local DamageResult = DamageResult.New()
    DamageResult.from = damageInfo.from
    DamageResult.to = damageInfo.to
    DamageResult.is_critical_hit = _is_critical_hit
    DamageResult.is_break_defense = _is_break_defense

    --- 格挡
    if to_property.damage_parrying > 0 then
        -- 伤害 > 0 并且有格挡属性，进行格挡计算
        if to_property.damage_parrying > damage then
            -- 伤害小于格挡值，伤害归0
            DamageResult.damage = 0
            DamageResult.parrying_damage = damage
        else
            DamageResult.damage = damage - to_property.damage_parrying
            DamageResult.parrying_damage = to_property.damage_parrying
        end
    else
        -- 没格挡值不计算格挡
        DamageResult.damage = damage
        DamageResult.parrying_damage = 0
    end

    local DamageReflect = nil
    --- 伤害反弹只反弹普通伤害
    if to_property.damage_reflect > 0 then
        DamageReflect = DamageResult.New()
        local reflect = math.floor(DamageResult.damage * to_property.damage_reflect.Value / 10000)
        DamageReflect.from = damageInfo.to
        DamageReflect.to = damageInfo.from
        DamageReflect.damage = reflect
    end

    table.insert(damageResultList, DamageResult)
    if DamageReflect ~= nil then
        table.insert(damageResultList, DamageReflect)
    end
end

--- 计算技能攻击结果
---@param damageInfo DamageInfo
function DamageManager:GetDamageResult_Skill(damageInfo)

end

--- 计算Buff攻击结果
---@param damageInfo DamageInfo
function DamageManager:GetDamageResult_Buff(damageInfo)

end

return DamageManager
--- 得到结论 XXX 对 XXX 因为XX 造成了 XX伤害，伤害的组成是由 {a, b, c} 组成