function permgen(a, n)
    n = n or #a
    if n <= 1 then
        coroutine.yield(a)
    else
        for i = 1, n do
            a[n], a[i] = a[i], a[n]
            permgen(a, n-1)
            a[n], a[i] = a[i], a[n]
        end
    end
end

function printResult(a)
    for i = 1, #a do
        io.write(a[i], " ")
    end
    io.write("\n")
end

function permutations(a)
    local co = coroutine.create(function()
        permgen(a)
    end)
    return function()
        print("permgen")
        local code, res = coroutine.resume(co)
        return res
    end
end

for p in permutations({"a", "b", "c"}) do
    printResult(p)
end
--permgen({1,2,3,4})