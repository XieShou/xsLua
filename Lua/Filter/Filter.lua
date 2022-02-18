local Filter = {}

function Filter:AllOf(...)
    for i, v in ipairs({...}) do
        table.insert(self._all_of, v)
        self._all_of_count = self._all_of_count + 1
    end
    return self
end

function Filter:AnyOf(...)
    for i, v in ipairs({...}) do
        table.insert(self._any_of, v)
        self._any_of_count = self._any_of_count + 1
    end
    return self
end

function Filter:NoneOf(...)
    for i, v in ipairs({...}) do
        table.insert(self._none_of, v)
        self._none_of_count = self._none_of_count + 1
    end
    return self
end

---@return Filter
function Filter.New()
    ---@class Filter
    local obj = {}
    --- 任何一个满足
    obj._any_of = {}
    obj._any_of_count = 0

    --- 所有条件满足
    obj._all_of = {}
    obj._all_of_count = 0

    --- 都不能满足
    obj._none_of = {}
    obj._none_of_count = 0

    setmetatable(obj, {
        __index = Filter,
        __call = function(obj, k, v)
            for i = 1, obj._all_of_count do
                if not obj._all_of[i](k, v) then
                    return false
                end
            end

            for i = 1, obj._none_of_count do
                if obj._none_of[i](k, v) then
                    return false
                end
            end

            for i = 1, obj._any_of_count do
                if obj._any_of[i](k, v) then
                    break
                end
                if i == obj._any_of_count then
                    return false
                end
            end
            return true
        end
    })
    return obj
end

return Filter