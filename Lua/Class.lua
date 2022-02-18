local function call_ctor(obj, cls, ...)
    if cls.__super then
        call_ctor(obj, cls.__super, ...)
    end
    if cls.__ctor then
        cls.__ctor(obj, ...)
    end
end
local function call_dtor(obj, cls)
    if cls.__dtor then
        cls.__dtor(obj)
    end
    if cls.__super then
        call_dtor(obj, cls.__super)
    end
end

--- Class只是一个保存继承关系的table，需要调用New进行实例
--- 否则就只是一个table，无法索引父类函数
local Class = function(name, super)
    local cls = {}
    cls.__ctor = false
    cls.__dtor = false
    cls.__cls_name = name

    cls._get_cls_name = function()
        return cls.__cls_name
    end
    cls.__meta_tb = {
        __index = function(tb, key)
            -- 从当前实例的基类中找，找不到就从父类中找
            local ex = cls
            local v = ex[key] --现在当前类中找，找不到再去基类找
            if v ~= nil then
                tb[key] = v
                return v
            end
            while ex.__super ~= nil do
                local value = ex.__super[key]--如果写了__newindex就要用rawget
                if value then
                    tb[key] = value
                    return value
                else
                    ex = ex.__super
                end
            end
            return nil
        end,
        --__mode = "kv", -- 设置弱引用表，方便hotfix
    }
    cls.New = function(...)
        ---@class Class
        local obj = {}
        obj.__ctor = false
        obj.__dtor = false
        setmetatable(obj, cls.__meta_tb)
        call_ctor(obj, cls, ...)

        return obj
    end

    cls.Destroy = function(self)
        call_dtor(self, cls)
    end

    cls.__super = super
    return cls
end

_G.Class = Class