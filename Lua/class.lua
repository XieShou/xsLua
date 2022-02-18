--[[
class支持多继承，且采用与Python一致的MRO算法

定义一个类的语法为ChildClass = class(ParentClass1, ParentClass2, ...)，无父类的类可定义为BaseClass = class()
创建一个对象的语法为local obj = ChildClass.new(...)

子类的构造函数及普通函数均不会自动调用父类的同名函数，需要显示的使用语法class.super.xxx(self, ...)进行调用
class.super.xxx只能访问到父类（父类上找不到会向更上面找)上的方法，无法访问到父类上的属性

访问子类没有但父类有的方法，访问到后会在子类缓存，如果父类方法被替换，子类会自动解除对旧方法的缓存
访问类上定义的属性（不是方法），建议直接使用class.xxx的方式，self.xxx在self上没有同名属性时，会去类上及父类上寻找，但父类属性不会被子类缓存

local A = class()
local B = class(A)
local C = class(B)
local D = class(C)

function A:test()
end
function B:test()
    B.super.test(self)
end
function C:test()
    C.super.test(self)
end
function D:test()
    D.super.test(self)
end

local obj = D.new()
for _ = 1, 10000000 do
    obj:test()
end

在仅支持单继承的旧写法中，以上代码运行总时间为3.01s
在支持多继承的新写法中，以上代码运行总时间为3.65s
--]]

local type = type
local table = table
local setmetatable = setmetatable
local getmetatable = getmetatable
local ipairs = ipairs
local assert = assert
local error = error

local _class = {}

-- gen method resolution order use C3 linearization
local function cls_gen_mro(cls, ...)
    local mroMergeList = {}
    local parentList = table.pack(...)
    if #parentList > 0 then
        for _, parent in ipairs(parentList) do
            local mroMerge = {}
            for _, c in ipairs(_class[parent]._mro) do
                table.insert(mroMerge, c)
            end
            table.insert(mroMergeList, mroMerge)
        end
        table.insert(mroMergeList, parentList)
    end

    local clsMRO = { cls }
    while #mroMergeList > 0 do
        local parent
        for _, mroMerge in ipairs(mroMergeList) do
            local candidate = mroMerge[1]

            local valid = true
            for _, mroTest in ipairs(mroMergeList) do
                if #mroTest > 1 then
                    for idx = 2, #mroTest do
                        if candidate == mroTest[idx] then
                            valid = false
                            break
                        end
                    end
                    if not valid then
                        break
                    end
                end
            end

            if valid then
                local newMROMergeList = {}
                for _, mro in ipairs(mroMergeList) do
                    for idx = 1, #mro do
                        if candidate == mro[idx] then
                            table.remove(mro, idx)
                            break
                        end
                    end
                    if #mro > 0 then
                        table.insert(newMROMergeList, mro)
                    end
                end
                mroMergeList = newMROMergeList

                parent = candidate
                break
            end
        end

        if not parent then
            error("class inherit relation conflict, cls_gen_mro failed")
        end

        table.insert(clsMRO, parent)
    end

    return clsMRO
end

local function cls_search_mro(cls, obj)
    local mro = _class[getmetatable(obj)]._mro
    for idx = 1, #mro do
        if cls == mro[idx] then
            return mro[idx + 1]
        end
    end
    return nil
end

local function cls_obj_index(obj, key)
    local cls = getmetatable(obj)
    local value = cls[key]
    if value then
        return value
    end

    local meta = _class[cls]
    value = meta._funcCache[key]
    if value then
        return value
    end

    local parent = cls
    while parent do
        parent = cls_search_mro(parent, obj)
        if parent then
            value = parent[key]
            if value then
                if type(value) == "function" then
                    meta._funcCache[key] = value
                end
                return value
            end
        end
    end

    return nil
end

local Object
Object = {
    ctor = function() end,
    dtor = function() end,
    mro = function() return { Object } end,
    tostring = function() return "Object" end
}
_class[Object] = {
    _parents = {},
    _mro = { Object }
}

function class(parent1, ...)
    if not parent1 then
        assert(#table.pack(...) == 0)
        parent1 = Object
    end

    local cls = {}
    local meta = {}
    _class[cls] = meta

    meta._parents = table.pack(parent1, ...)
    meta._mro = cls_gen_mro(cls, parent1, ...)
    meta._funcCache = setmetatable({}, { __mode = "kv" })
    meta._superFuncCache = setmetatable({}, { __mode = "kv" })

    cls.ctor = false
    cls.dtor = false
    cls.mro = function()
        local mro = {}
        for _, c in ipairs(meta._mro) do
            table.insert(mro, c)
        end
        return mro
    end
    cls.super = setmetatable({}, {
        __index = function(_, key)
            local func = meta._superFuncCache[key]
            if func then
                return func
            end

            return function(obj, ...)
                local parent = cls
                while parent do
                    parent = cls_search_mro(parent, obj)
                    if parent then
                        local value = parent[key]
                        if type(value) == "function" then
                            meta._superFuncCache[key] = value
                            return value(obj, ...)
                        end
                    end
                end

                error(key .. " not found")
            end
        end,
        __metatable = "readonly"
    })
    cls.new = function(...)
        local obj = setmetatable({}, {
            __index = cls_obj_index,
            __tostring = cls.__tostring,
            __len = cls.__len,
            __pairs = cls.__pairs,
            __call = cls.__call,
            __gc = cls.dtor,
            __metatable = cls
        })
        obj:ctor(...)
        return obj
    end

    return cls
end