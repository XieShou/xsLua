--- 属性值类型
---@class EPropertyType
local EPropertyType = {
    --- 攻击（Attack_Point）
    AP = 1,
    --- 防御（Defense_Point）
    DP = 2,
    --- 血量（Health_Point）
    HP = 3,
    --- 蓝量（Magic_Point）
    MP = 4,
    --- 能量（Power_Point）
    PP = 5,
    --- 经验（Experience_Point）
    EXP = 6,
    --- 等级（Level）
    LV = 7,
    --- 攻击速度
    Attack_Speed = 8,
    --- 速度
    Speed = 9,

    --- 力量
    Strength = 21,
    --- 敏捷
    Agility = 22,
    --- 智力
    Intellect = 23,
    --- 精神
    Spirit = 24,
    --- 活力
    Vitality = 25,

    --- 命中
    Accuracy = 31,
    --- 闪避
    Dodge = 32,

    --- 暴击
    Critical_Hit_Value = 201,
    --- 暴击率
    Critical_Hit_Rate = 202,
    --- 暴击率抵抗
    Critical_Hit_Rate_Defence = 203,

    --- 破防
    Break_Defense_Value = 401,
    --- 破防率
    Break_Defense_Rate = 402,
    --- 破防率抵抗
    Break_Defense_Rate_Defence = 403,

    --- 格挡
    Damage_Parrying = 405,

    --- 伤害加深
    Damage_Increase = 601,
    --- 减伤率
    Damage_Decrease = 602,

    --- 伤害反弹
    Damage_Reflect = 603,

    --- 纯粹伤害
    Holy_Damage = 501,
}
_G.EPropertyType = EPropertyType
return EPropertyType