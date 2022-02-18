---@class Property
local Property = {}

---@type Property[]
local PropertyPool = {}

---@return Property
local function Pop()
    local length = #PropertyPool
    if length > 0 then
        local property = PropertyPool[length]
        PropertyPool[length] = nil
        return property
    else
        return nil
    end
end

---@param property Property
local function Push(property)
    table.insert(PropertyPool, property)
end

function Property:Init()
    --region 在这里都是当前帧计算完属性的结果值
    --- 攻击力
    self.attack_point = 1
    --- 防御力
    self.defense_point = 1
    --- 血量
    self.hp = 1
    --- 蓝量
    self.mp = 1
    --- 能量
    self.pp = 1
    --- 经验
    self.exp = 0
    --- 等级
    self.lv = 1

    --- 命中
    self.accuracy = 0
    --- 闪避
    self.dodge = 0

    --- 暴击伤害加成
    self.critical_hit_value = 0
    --- 暴击率
    self.critical_hit_rate = 0
    --- 暴击率抵抗
    self.critical_hit_rate_defence = 0

    --- 破防
    self.break_defense_value = 0
    --- 破防率
    self.break_defense_rate = 0
    --- 破防率抵抗
    self.break_defense_rate_defence = 0

    --- 格挡
    self.damage_parrying = 0

    --- 伤害加深
    self.damage_increase = 0
    --- 减伤
    self.damage_decrease = 0

    --- 伤害反弹
    self.damage_reflect = 0

    --- 纯粹伤害
    self.holy_damage = 0

    --endregion
end

function Property:GetProperty()
    
end

function Property:SetProperty()
    
end

---@return Property
function Property.New()
    local obj = Pop()
    if obj then
        return obj
    else
        obj = {}
        setmetatable(obj, Property)
        return obj
    end
end

---@param self Property
function Property.Release(self)
    Push(self)
end

return Property