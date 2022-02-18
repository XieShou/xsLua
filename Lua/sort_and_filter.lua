--- 排序
---@alias FilterFunc fun(i:any, v:any):boolean
---@param filterFunc FilterFunc
local function todo(p, data, filterFunc, sortFunc)
    assert(data)
    local result = {}
    if not filterFunc then
        result = data
    else
        if type(filterFunc) == "function" then
            for i, v in p(data) do
                if filterFunc(i, v) then
                    table.insert(result)
                end
            end
        else
            for i, v in p(data) do
                table.insert(result)
            end
        end
    end
    if sortFunc then
        table.sort(result, sortFunc)
    end
    return result
end

return {
    todo = todo,
}