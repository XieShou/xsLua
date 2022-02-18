local arr = {
    414,399,866,582,147,861,955,526,20,62,916,193,468,905,256,969,875,715,74,267}
    --987,703,125,585,808,741,696,931,803,744,267,489,364,520,492,641,12,555,228,729,
    --598,1,511,622,333,194,890,623,906,345,651,235,692,268,160,751,130,956,343,634,
    --795,542,617,535,205,619,367,532,361,824,374,659,362,478,69,97,160,424,523,406,
    --903,406,164,599,379,564,265,986,945,962,291,5,545,457,266,879,310,263,372,583

local function _print(list, l, r)
    if l < r then
        local ss = ""
        for i = l, r do
            ss = ss .. list[i] .. ","
        end
        print(ss)
    end
end
_print(arr, 1, #arr)
local function swap(list, l, r)
    list[l], list[r] = list[r], list[l]
end

local function partition(list, left, right)
    local pivot = left --跟这个位置的值进行比较
    local index = left + 1

    for i = index, right do
        if list[i] < list[pivot] then --i位置比1位置的值大
            _print(list, left, right)
            swap(list, i, index)
            index = index + 1
            _print(list, left, right)
            --pivot = i
        end
    end
    swap(list, pivot, index - 1);
    return index - 1
end

local function quickly_sort(list, left, right)
    if left < right then
        local mid = partition(list, left, right)
        print(mid)
        _print(list, left, right)
        quickly_sort(list, left, mid - 1)
        quickly_sort(list, mid + 1, right)
    end
    return list
end

quickly_sort(arr, 1, #arr)

local curr = -1
local ss = ""
local pass = true
for i = 1, #arr do
    if curr <= arr[i] then
        curr = arr[i]

    else
        pass = true
    end
    ss = ss .. curr .. ","
end
if pass then
    print(ss)
    print("success")
else
    error("fail")
end

--local arr = ""
--for i = 1, 100 do
--    arr = arr .. "," .. math.random(1, 1000)
--    if i % 20 == 0 then
--        arr = arr .. "\n"
--    end
--end
--
--print(arr)